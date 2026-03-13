{ inputs, ... }:
{
  flake.modules.homeManager.ai =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [
        unstable.claude-code
      ];

      home.file.".claude/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/programs/ai [nd]/claude/settings.json";
    };
}
