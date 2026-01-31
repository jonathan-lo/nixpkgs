{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      calibre
      google-chrome
      ungoogled-chromium
    ];
  };

  modules = {
    bitwarden.enable = true;
    java.enable = true;
  };

  imports = [ ../../../home.nix ];
}
