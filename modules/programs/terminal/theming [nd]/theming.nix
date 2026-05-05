# modules/programs/theming [nd]/theming.nix
{ inputs, ... }:
{
  # Home-manager theming for any OS
  flake.modules.homeManager.theming =
    { lib, ... }:
    {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      # catppuccin's opencode module requires programs.opencode.tui which is
      # only on home-manager master, not release-25.11
      options.programs.opencode.tui = lib.mkOption {
        type = lib.types.anything;
        default = { };
      };

      # Enable catppuccin globally
      config.catppuccin = {
        enable = true;
        flavor = "mocha";
        btop.enable = true;
        ghostty.enable = false; # managed via dotfiles
      };
    };
}
