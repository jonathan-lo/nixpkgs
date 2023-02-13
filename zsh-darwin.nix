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

    profileExtra = ''
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      export NIX_SSL_CERT_FILE=/Library/Certificates/allcerts.pem
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

      gpgconf --launch pg-agent
      gpg-connect-agent updatestartuptty /bye > /dev/null
    '';
    shellAliases = aliases;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };

}
