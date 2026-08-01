{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "claude-code" ];

  flake.modules.darwin.ai =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.unstable.cmux ];
    };

  flake.modules.homeManager.ai =
    { pkgs, ... }:
    {
      # The harnesses themselves. The tooling around them — the Claude settings merge
      # (claude/settings.nix), the skill linker (agent-skills.nix) and the skills it
      # links (speckit.nix, plannotator.nix) — merges into this same module from the
      # sibling files rather than being imported here.
      home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        # harnesses
        claude-code
        # codex
        pi

        # usage
        ccusage

        # coordination
        agent-deck
      ];
    };
}
