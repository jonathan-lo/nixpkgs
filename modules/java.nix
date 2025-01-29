{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
  ];

  programs.java = {
    enable = true;
  };
}
