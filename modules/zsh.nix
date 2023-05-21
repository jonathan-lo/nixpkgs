{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.zsh;

  aliases = {
    dk = "docker";
    l = "ls";
    ll = "ls -l";
    ls = "ls --color=tty";
    ssh = "TERM=xterm-256color ssh";
    tf = "terraform";
  };
in
{
  options.modules.shell.zsh = {
    aliases = mkOption {
      description = "additional shell aliases";
      type = types.attrs;
    };
    profileExtra = mkOption {
      description = "extra profile commands";
      type = types.lines;
    };
  };
  config.programs.zsh = mkMerge [{
    enable = true;
    initExtraFirst = ''
      export PATH=$PATH:$HOME/bin
      export PATH=$PATH:$HOME/go/bin
      export PATH=/opt/homebrew/bin:$PATH
      export DOCKER_HOST=unix://$HOME/.docker/docker.sock
      export REQUESTS_CA_BUNDLE="/Library/Certificates/allcerts.pem"
    '';
    profileExtra = cfg.profileExtra;
    shellAliases = aliases // cfg.aliases;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  }];
}
