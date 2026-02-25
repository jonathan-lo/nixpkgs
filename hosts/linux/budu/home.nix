{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      google-chrome
      ungoogled-chromium
    ];
  };

  imports = [ ../../../home.nix ];
}
