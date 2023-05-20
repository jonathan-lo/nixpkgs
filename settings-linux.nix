{ config, pkgs, ... }:

{
  home = {
    username = "jlo";
    homeDirectory = "/home/jlo";
  };

  settings = {
    alacritty.fontName = "FuraMono Nerd Font Mono";
    zsh.profileExtra = ". /home/jlo/.nix-profile/etc/profile.d/nix.sh";
    git.email = "3763897+jonathan-lo@users.noreply.github.com";
  };
}
