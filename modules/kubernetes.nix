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

  modules.shell.zsh.aliases = {

    k = "kubectl";
    ka = "kubectl apply -f";
    kd = "kubectl describe";
    ke = "kubectl edit";
    kg = "kubectl get";
    kgp = "kubectl get pod";
    klog = "kubectl logs";
    kn = "kubectl config set-context --current --namespace";
    kpf = "kubectl port-forward";
    krm = "kubectl delete";
    krr = "kubectl rollout restart";
  };
}
