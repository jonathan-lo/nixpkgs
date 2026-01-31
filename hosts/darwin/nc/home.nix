
{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
    ];
  };

  modules.java.enable = true;

  imports = [ ../../../home.nix ];
}
