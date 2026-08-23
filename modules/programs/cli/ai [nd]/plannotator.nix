{ inputs, ... }:
{
  # Merges into the `ai` module; the linking itself lives in agent-skills.nix.
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      plannotator = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.plannotator;

      # Plannotator's slash commands ship as skills in its repo, normally installed by the
      # upstream curl installer; the Nix package carries only the binary. Taking them from
      # the package's own source keeps the skills in lockstep with the packaged CLI, and
      # copying them out drops the 40M+ repo checkout from the generation's closure.
      plannotatorSkills = pkgs.runCommand "plannotator-claude-skills" { } ''
        mkdir -p "$out"
        cp -R ${plannotator.src}/apps/skills/core/. "$out/"
      '';
    in
    {
      home.packages = [ plannotator ];

      # These skills are harness-neutral, so both harnesses take them as-is.
      settings.agentSkills.sources.plannotator = {
        src = plannotatorSkills;
        globPrefix = "plannotator-";
        targets = [
          "claude"
          "pi"
        ];
      };
    };
}
