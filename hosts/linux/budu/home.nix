
{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      calibre
    ];
  };

  imports = [ ../../../home.nix ];
}
