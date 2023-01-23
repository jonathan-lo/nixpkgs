{ config, lib, pkgs, ... }:

with lib;
let cfg = config.settings.git;
in {
  options.settings.git = {
    defaultBranch = mkOption {
      description = "the name of the default branch";
      default = "main";
      example = "main";
      type = types.str;
    };
    email = mkOption {
      description = "the email address to use for <user.email> in git config";
      example = "reginald@google.com";
      type = types.str;
    };
    enableLargeFileStorage = mkOption {
      description = "whether to enable large file storage support";
      default = false;
      example = true;
      type = types.bool;
    };
  };

  config.programs.git = {
    enable = true;

    aliases = {
      ci = "commit";
      co = "checkout";
      l = "lg -n 10";
      lg =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      st = "status";
    };

    extraConfig = {
      core = { editor = "nvim"; };
      init = { defaultBranch = cfg.defaultBranch; };
    };

    lfs.enable = cfg.enableLargeFileStorage;

    userEmail = cfg.email;
    userName = "Jonathan Lo";
  };
}
