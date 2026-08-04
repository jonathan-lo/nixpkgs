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
      # Every workmux worktree on the machine, open or closed. Backs the picker's
      # ctrl-o view and the open-worktree section of its default view. Does not
      # call workmux -- see the script for why it can't.
      workmux-worktrees = pkgs.writeShellApplication {
        name = "workmux-worktrees";
        runtimeInputs = with pkgs; [
          git
          tmux
          coreutils
        ];
        text = builtins.readFile ./scripts/workmux-worktrees.sh;
      };

      # Opening view of the `sesh` picker: open worktrees, tmux sessions, this
      # config, then every repo in the configured GitHub orgs. `gh-repos` is
      # resolved from PATH (it belongs to the ghRepos module), as the picker's
      # ctrl-r bind already does.
      sesh-default-list = pkgs.writeShellApplication {
        name = "sesh-default-list";
        runtimeInputs = with pkgs; [
          workmux-worktrees
          unstable.sesh
          gnugrep
          coreutils
        ];
        text = builtins.readFile ./scripts/sesh-default-list.sh;
      };

      # Resolves a `sesh` picker selection. Worktree paths are handed to
      # `workmux open` so they come back with their configured pane layout.
      # `gh-repos` entries look like `owner/name`; those are cloned into
      # ~/code/github/owner/name (shown in a popup) when missing, then connected
      # to as a session. Every other selection (paths, zoxide/find results,
      # session names) is passed through to `sesh connect` untouched.
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
            sesh-default-list # picker's opening view
            workmux-worktrees # every workmux worktree, open or closed
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
