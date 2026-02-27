{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    stateVersion = "22.05";
    username = "jlo";
  };

  imports = [
    ./_legacy-modules/lazyvim
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
