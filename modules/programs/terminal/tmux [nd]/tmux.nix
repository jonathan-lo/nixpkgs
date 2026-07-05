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
        text = ''
          sel="''${1:-}"
          [ -z "$sel" ] && exit 0

          root="''${GH_REPOS_ROOT:-$HOME/code/github}"

          if [ ! -e "$sel" ] && printf '%s' "$sel" | grep -qE '^[^[:space:]/]+/[^[:space:]/]+$'; then
            dir="$root/$sel"
            if [ ! -d "$dir" ]; then
              mkdir -p "$(dirname "$dir")"
              tmux display-popup -w 80% -h 60% -E "gh repo clone $sel $dir"
            fi
            if [ -d "$dir" ]; then
              sel="$dir"
            fi
          fi

          exec sesh connect "$sel"
        '';
      };
    in
    {
      home = {
        packages =
          with pkgs;
          [
            unstable.sesh # tmux session switcher
            sesh-connect # picker glue: clone + connect gh-repos entries
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
