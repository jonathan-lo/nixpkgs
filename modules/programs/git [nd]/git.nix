{ inputs, ... }:
{
  flake.modules.homeManager.git =
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
        privateOrgs = mkOption {
          description = ''
            GitHub orgs whose repositories are private. Consumed by `ghRepos`
            (repos to list) and `go` (GOPRIVATE). List options concatenate across
            modules, so the private submodule contributes the actual org names
            without them appearing in the public repo.
          '';
          default = [ ];
          example = [ "kubernetes" ];
          type = types.listOf types.str;
        };
      };

      config = {
        home.packages = with pkgs; [
          unstable.gh
          jujutsu
          #    gitbutler
          lazygit
        ];

        programs.git = {
          enable = true;

          settings = {
            credential = {
              helper = "";
            };
            credential."https://github.com" = {
              helper = "!gh auth git-credential";
            };
            credential."https://gist.github.com" = {
              helper = "!gh auth git-credential";
            };
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
            # rewrite GitHub SSH remotes to HTTPS so auth flows through the gh
            # credential helper (configured above) rather than SSH keys
            url."https://github.com/".insteadOf = [
              "git@github.com:"
              "ssh://git@github.com/"
            ];
            user = {
              email = cfg.email;
              name = "Jonathan Lo";
            };
          };

          ignores = [
            "**/.claude/settings.local.json"
            "kls_database.db"
            ".idea/GitLink.xml"
            ".envrc"
          ];
        };
      };
    };
}
