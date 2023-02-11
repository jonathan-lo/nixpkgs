{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.istioctl
    unstable.kubebuilder
    opa
    operator-sdk
  ];
}
