{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bun
    unstable.claude-code
    python313
  ];
}
