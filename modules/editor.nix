{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    exercism
    helix
    zed-editor
  ];
}
