{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
#    unstable.gofumpt
#    unstable.gopls
    gofumpt
    gopls
  ];

  programs.go = {
    enable = true;
#    package = pkgs.unstable.go;
  };
}
