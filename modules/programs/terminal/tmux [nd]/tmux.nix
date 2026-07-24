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

      # Opens a dedicated `claude` tmux session rooted at the cwd, or adds a new
      # window (named after the cwd) if that session already exists, then focuses
      # it.
      claude-session = pkgs.writeShellApplication {
        name = "claude-session";
        runtimeInputs = with pkgs; [
          tmux
          coreutils
        ];
        text = builtins.readFile ./scripts/claude-session.sh;
      };
    in
    {
      home = {
        packages =
          with pkgs;
          [
            unstable.sesh # tmux session switcher
            sesh-connect # picker glue: clone + connect gh-repos entries
            claude-session # dedicated `claude` tmux session per project
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
