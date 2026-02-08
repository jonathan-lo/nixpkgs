{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      google-chrome
      ungoogled-chromium
    ];
  };

  modules = {
    bitwarden.enable = true;
    calibre.enable = true;
    firefox.enable = true;
    java.enable = true;
  };

  imports = [ ../../../home.nix ];
}
