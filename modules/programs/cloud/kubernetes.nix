{ inputs, ... }:
{
  flake.modules.homeManager.kubernetes =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        unstable.kargo
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
        tlsx
      ];

      modules.shell.zsh.initContent = ''
        kc() {
          gcloud container clusters get-credentials "''${1}" --dns-endpoint
        }
        _kc() {
          compadd $(gcloud container clusters list --format='value(name)' 2>/dev/null)
        }
        compdef _kc kc
      '';

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
    };
}
