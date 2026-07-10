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

      # Opens a dedicated `claude` tmux session rooted at the cwd, or adds a new
      # window (named after the cwd) if that session already exists, then focuses
      # it.
      claude-session = pkgs.writeShellApplication {
        name = "claude-session";
        runtimeInputs = with pkgs; [
          tmux
          coreutils
        ];
        text = ''
          session="claude"
          cwd="$PWD"
          window="$(basename "$cwd")"

          if tmux has-session -t "=$session" 2>/dev/null; then
            tmux new-window -t "=$session" -c "$cwd" -n "$window"
          else
            tmux new-session -d -s "$session" -c "$cwd" -n "$window"
          fi

          if [ -n "''${TMUX:-}" ]; then
            tmux switch-client -t "=$session"
          else
            tmux attach-session -t "=$session"
          fi
        '';
      };

      # https://github.com/craftzdog/tmux-claude-session-manager — a popup picker
      # (prefix+u) listing every running Claude agent with live status, plus a
      # per-directory launcher (prefix+y). Not in nixpkgs, so build it from source
      # and wrap the picker scripts so their runtime deps resolve without relying
      # on the interactive PATH. `claude` is left to the login shell so the picker
      # uses the same version the user runs.
      claude-session-manager = pkgs.tmuxPlugins.mkTmuxPlugin {
        pluginName = "claude-session-manager";
        version = "0-unstable-2026-07-09";
        rtpFilePath = "claude_session_manager.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "craftzdog";
          repo = "tmux-claude-session-manager";
          rev = "45d593f7e17d34fd5bad5330f825d430e817938e";
          hash = "sha256-hiV6Zsfbs0XwY+Mko0DnxrxH4ke8xOqhdEMkerFN0pY=";
        };
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postInstall =
          let
            runtimeInputs =
              with pkgs;
              [
                tmux
                fzf
                jq
                gawk
                gnugrep
                gnused
                coreutils
              ]
              # Linux has no system ps; agents.sh needs `ps -Ao pid=,tty=`.
              ++ lib.optionals stdenv.isLinux [ procps ];
          in
          ''
            # Pin the interpreter to store bash before wrapping: the wrapProgram
            # wrappers below exec `.<name>-wrapped` directly, and the PATH they
            # inject carries the runtime deps but not bash, so an
            # `#!/usr/bin/env bash` shebang would have nothing to resolve against.
            for file in "$target"/*.tmux "$target"/scripts/*.sh; do
              substituteInPlace "$file" \
                --replace-fail "#!/usr/bin/env bash" "#!${pkgs.bash}/bin/bash"
            done
            for script in launch list picker agents; do
              wrapProgram "$target/scripts/$script.sh" \
                --prefix PATH : ${lib.makeBinPath runtimeInputs}
            done
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
          {
            plugin = claude-session-manager;
          }
        ];
      };
    };
}
