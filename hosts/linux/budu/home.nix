{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      calibre
      google-chrome
      ungoogled-chromium
    ];
  };

  modules.java.enable = true;

  imports = [ ../../../home.nix ];
}
