{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.settings.bash;

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
  config.programs.bash = {
    enable = true;

    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historyIgnore = [ "cd" "exit" "history" "l" "ll" "ls" "pwd"  ];

  #  initExtra = ''
  #    PS1="\e[0;32m; \e[0m"
  #    set -o vi
  #  '';
    profileExtra = ". /home/jlo/.nix-profile/etc/profile.d/nix.sh";
    shellAliases = aliases;
  };
}
