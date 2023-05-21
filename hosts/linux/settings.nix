{ config, pkgs, ... }:

{
  home = {
    username = "jlo";
    homeDirectory = "/home/jlo";
  };

  settings = {
    alacritty.fontName = "FuraMono Nerd Font Mono";
  };


  modules.shell.zsh = {
    profileExtra = ". /home/jlo/.nix-profile/etc/profile.d/nix.sh";
  };
}
