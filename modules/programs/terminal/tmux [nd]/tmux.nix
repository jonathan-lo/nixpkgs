# modules/programs/tmux [nd]/tmux.nix
{ inputs, ... }:
let
  configDir = ./config;
  configFiles = builtins.attrNames (builtins.readDir configDir);
in
{
  flake.modules.homeManager.tmux =
    { pkgs, lib, ... }:
    {
      home = {
        packages =
          with pkgs;
          [
            unstable.sesh # tmux session switcher
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
