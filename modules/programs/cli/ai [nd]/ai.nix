{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "claude-code" ];

  flake.modules.homeManager.ai =
    { config, pkgs, ... }:
    {
      home.packages = [
        pkgs.unstable.claude-code
        inputs.llm-agents.packages.${pkgs.system}.spec-kit

        # usage
        inputs.llm-agents.packages.${pkgs.system}.agentsview
        inputs.llm-agents.packages.${pkgs.system}.ccusage
      ];

      home.file.".claude/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/programs/cli/ai [nd]/claude/settings.json";
    };
}
