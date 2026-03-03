{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    stateVersion = "22.05";
    username = "jlo";
  };
}
