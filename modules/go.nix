{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.gofumpt
    unstable.gopls
  ];

  programs.go = {
    enable = true;
    package = pkgs.unstable.go;
  };
}
