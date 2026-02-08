{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.shell.zsh;

  aliases = {
    dk = "docker";
    i = "idea . &";
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
      default = "";
    };
    initContent = mkOption {
      description = "extra init content";
      type = types.lines;
      default = "";
    };
  };
  config.programs.zsh = mkMerge [
    {
      enable = true;
      initContent = cfg.initContent;
      profileExtra = cfg.profileExtra;
      shellAliases = aliases // cfg.aliases;

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
    }
  ];
}
