{ inputs, ... }:
{
  # Merges into the `ai` module; the linking itself lives in agent-skills.nix.
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      specKit = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.spec-kit;

      # The Claude integration of spec-kit ships as skills (.claude/skills/speckit-*).
      # `specify init` scaffolds them offline from assets bundled in the pinned CLI, so
      # the generated skills always match the packaged spec-kit version. Bumping the
      # llm-agents input (via `just update`) regenerates them on the next `just apply` —
      # no static copies to rot.
      speckitSkills = pkgs.runCommand "speckit-claude-skills" { nativeBuildInputs = [ specKit ]; } ''
        export HOME="$TMPDIR/home"
        mkdir -p "$HOME" proj
        cd proj
        specify init --here --integration claude --script sh --ignore-agent-tools --force
        mkdir -p "$out"
        cp -R .claude/skills/. "$out/"
      '';
    in
    {
      home.packages = [ specKit ];

      # Claude only: spec-kit's other integrations emit prompts rather than skills.
      settings.agentSkills.sources.speckit = {
        src = speckitSkills;
        globPrefix = "speckit-";
        targets = [ "claude" ];
      };
    };
}
