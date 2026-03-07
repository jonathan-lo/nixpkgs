{ inputs, ... }:
{
  flake.modules.homeManager.zsh =
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
        enableProfiling = mkOption {
          description = "enable zsh profiling with zprof";
          type = types.bool;
          default = false;
        };
      };

      config.programs.zsh = mkMerge [
        {
          enable = true;
          initContent = mkMerge [
            (mkBefore (
              ''
                # Skip oh-my-zsh compinit, we'll do it manually with caching
                skip_global_compinit=1
              ''
              + optionalString cfg.enableProfiling ''
                zmodload zsh/zprof
              ''
            ))
            cfg.initContent
            (mkAfter (
              ''
                # Use cached completions - skip regeneration
                autoload -Uz compinit
                compinit -C
              ''
              + optionalString cfg.enableProfiling ''
                zprof
              ''
            ))
          ];
          profileExtra = cfg.profileExtra;
          shellAliases = aliases // cfg.aliases;

          oh-my-zsh = {
            enable = true;
            plugins = [ "git" ];
            theme = "robbyrussell";
          };
        }
      ];
    };
}
