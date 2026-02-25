{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      google-chrome
      ungoogled-chromium
    ];
  };

  modules = {
    calibre.enable = true;
    firefox.enable = true;
    java.enable = true;
  };

  imports = [ ../../../home.nix ];
}
