{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    exercism
    #    gitbutler
    helix
    vscode
  ];
}
