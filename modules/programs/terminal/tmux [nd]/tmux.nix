# modules/programs/tmux [nd]/tmux.nix
{ inputs, ... }:
let
  configDir = ./config;
  configFiles = builtins.attrNames (builtins.readDir configDir);
in
{
  flake.modules.homeManager.tmux =
    { pkgs, lib, ... }:
    let
      # Resolves a `sesh` picker selection. `gh-repos` entries look like
      # `owner/name`; those are cloned into ~/code/github/owner/name (shown in a
      # popup) when missing, then connected to as a session. Every other
      # selection (paths, zoxide/find results, session names) is passed through
      # to `sesh connect` untouched.
      sesh-connect = pkgs.writeShellApplication {
        name = "sesh-connect";
        runtimeInputs = with pkgs; [
          unstable.sesh
          tmux
          gh
          git
          coreutils
          gnugrep
        ];
        text = builtins.readFile ./scripts/sesh-connect.sh;
      };

      # `workmux add` wrapper that names the new tmux session <root-repo>-<name>,
      # since workmux has no config token to prefix session names with the repo.
      workmux-add = pkgs.writeShellApplication {
        name = "workmux-add";
        runtimeInputs = [
          inputs.workmux.packages.${pkgs.stdenv.hostPlatform.system}.default
          pkgs.git
          pkgs.coreutils
        ];
        text = builtins.readFile ./scripts/workmux-add.sh;
      };
    in
    {
      home = {
        packages =
          with pkgs;
          [
            unstable.sesh # tmux session switcher
            sesh-connect # picker glue: clone + connect gh-repos entries
            workmux-add # `workmux add` with a <root-repo>-<name> session name
          ]
          ++ lib.optionals stdenv.isDarwin [
            terminal-notifier
          ];
      };
      programs.tmux = {
        enable = true;

        baseIndex = 1;
        customPaneNavigationAndResize = true;
        disableConfirmationPrompt = true;
        escapeTime = 0;
        historyLimit = 1000000;
        keyMode = "vi";
        prefix = "C-Space";
        sensibleOnTop = false;
        shell = "${pkgs.zsh}/bin/zsh";

        extraConfig = ''
          set -g default-command "${pkgs.zsh}/bin/zsh -l"
        ''
        + builtins.concatStringsSep "\n" (map (f: builtins.readFile (configDir + "/${f}")) configFiles);

        # theme is set by catppuccin module in theming.nix
        plugins = with pkgs.tmuxPlugins; [
          {
            plugin = tmux-thumbs;
          }
        ];
      };
    };
}
