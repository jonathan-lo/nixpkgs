{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    exercism
    vscode
  ];
}
