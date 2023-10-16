{ config, pkgs, ... }:

{
  home = {
    username = "jlo";
    homeDirectory = "/home/jlo";
  };

  settings = {
    alacritty.fontName = "FuraMono Nerd Font Mono";
  };
}
