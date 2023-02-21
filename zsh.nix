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
    tf = "terraform";
  };
in
{
  options.settings.zsh = {
    profileExtra = mkOption {
      description = "extra lines in .zshprofile";
      type = types.lines;
    };
  };
  config.programs.zsh = {
    enable = true;
    initExtraFirst = ''
      export PATH=$PATH:$HOME/bin
      export REQUESTS_CA_BUNDLE="/Library/Certificates/allcerts.pem"
    '';
    profileExtra = cfg.profileExtra; #". /home/jlo/.nix-profile/etc/profile.d/nix.sh";
    shellAliases = aliases;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

}
