{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      calibre
      google-chrome
      ungoogled-chromium
    ];
  };

  imports = [ ../../../home.nix ];
}
