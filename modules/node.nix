{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_22
    #unstable.claude-code
  ];
}
