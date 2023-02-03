{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.settings.zsh;

  aliases = {
    dk = "docker";
    k = "kubectl";
    ka = "kubectl apply -f";
    kg = "kubectl get";
    klog = "kubectl logs";
    kn = "kubectl config set-context --current --namespace";
    kpf = "kubectl port-forward";
    l = "ls";
    ll = "ls -l";
    ls = "ls --color=tty";
  };
in {
  config.programs.zsh = {
    enable = true;

#    profileExtra = ". /home/jlo/.nix-profile/etc/profile.d/nix.sh";
    shellAliases = aliases;

    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "robbyrussell";
    };
  };

}
