{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.settings.zsh;

  aliases = {
    dk = "docker";
    k = "kubectl";
    ka = "kubectl apply -f";
    kg = "kubectl get";
    kgp = "kubectl get pod";
    klog = "kubectl logs";
    kn = "kubectl config set-context --current --namespace";
    kpf = "kubectl port-forward";
    l = "ls";
    ll = "ls -l";
    ls = "ls --color=tty";
  };
in
{
  config.programs.zsh = {
    enable = true;

    profileExtra = ". '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'";
    shellAliases = aliases;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

}
