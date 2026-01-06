{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      calibre
      ghostty
      google-chrome
      ungoogled-chromium
    ];
  };

  imports = [ ../../../home.nix ];
}
