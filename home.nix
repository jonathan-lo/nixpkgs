{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    stateVersion = "22.05";
    username = "jlo";
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
