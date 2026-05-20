{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "claude-code" ];

  flake.modules.homeManager.ai =
    { config, pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
        ]
        ++ (with inputs.llm-agents.packages.${system}; [
          # harnesses
          claude-code
          codex

          spec-kit

          # usage
          agentsview
          ccusage
        ]);

      home.file.".claude/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/programs/cli/ai [nd]/claude/settings.json";
    };
}
