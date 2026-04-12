{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "claude-code" ];

  flake.modules.homeManager.ai =
    { config, pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [ unstable.claude-code ]
        ++ (with inputs.llm-agents.packages.${system}; [
          spec-kit

          # usage
          agentsview
          ccusage
        ]);

      home.file.".claude/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/programs/cli/ai [nd]/claude/settings.json";
    };
}
