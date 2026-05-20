# modules/programs/theming [nd]/theming.nix
{ inputs, ... }:
{
  # Home-manager theming for any OS
  flake.modules.homeManager.theming =
    { lib, ... }:
    {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      # catppuccin modules require options only available on home-manager
      # master, not release-25.11. Stub them out until we upgrade.
      options.programs = lib.genAttrs
        [ "antigravity" "cursor" "kiro" "vscodium" "windsurf" ]
        (_: lib.mkOption { type = lib.types.anything; default = { }; })
        // { opencode.tui = lib.mkOption { type = lib.types.anything; default = { }; }; };

      # Enable catppuccin globally
      config.catppuccin = {
        enable = true;
        flavor = "mocha";
        btop.enable = true;
        ghostty.enable = false; # managed via dotfiles
      };
    };
}
