# modules/programs/theming [nd]/theming.nix
{ inputs, ... }:
{
  # Home-manager theming for any OS
  flake.modules.homeManager.theming = { ... }: {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    # Enable catppuccin globally
    catppuccin = {
      enable = true;
      flavor = "mocha";
      btop.enable = true;
      ghostty.enable = false; # managed via dotfiles
    };
  };
}
