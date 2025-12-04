{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.settings.git;
in
{
  options.settings.git = {
    defaultBranch = mkOption {
      description = "the name of the default branch";
      default = "master";
      example = "main";
      type = types.str;
    };
    email = mkOption {
      description = "the email address to use for <user.email> in git config";
      default = "3763897+jonathan-lo@users.noreply.github.com";
      example = "reginald@google.com";
      type = types.str;
    };
  };

  config.programs.git = {
    enable = true;

    settings = {
      alias = {
        ci = "commit";
        co = "checkout";
        l = "lg -n 10";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        purr = "pull --rebase";
        st = "status";
      };
      core = {
        editor = "nvim";
      };
      init = {
        defaultBranch = cfg.defaultBranch;
      };
      push = {
        autoSetupRemote = "true";
      };
      user = {
        email = cfg.email;
        name = "Jonathan Lo";
      };
    };

    ignores = [
      "**/.claude/settings.local.json"
      "kls_database.db"
      ".idea/GitLink.xml"
    ];
  };
}
