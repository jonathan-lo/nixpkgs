{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.gofumpt
    unstable.gopls
    unstable.kubebuilder
  ];



  programs.go = {
    enable = true;

    package = pkgs.unstable.go;
  };
}
