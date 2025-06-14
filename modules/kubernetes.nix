{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    unstable.kind
    kn
    kubectx
    unstable.kubectl
    kubernetes-helm
    kubespy
    kubeswitch
    kustomize
    k9s
    stern
  ];

  modules.shell.zsh.aliases = {

    k = "kubectl";
    ka = "kubectl apply -f";
    kd = "kubectl describe";
    ke = "kubectl edit";
    kg = "kubectl get";
    kgp = "kubectl get pod";
    klog = "kubectl logs";
    kpf = "kubectl port-forward";
    krm = "kubectl delete";
    krr = "kubectl rollout restart";
  };
}
