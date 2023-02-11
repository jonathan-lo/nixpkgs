{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kind
    kubectx
    kubectl
    kubernetes-helm
    kubeswitch
    kustomize
    k9s
    stern
  ];
}
