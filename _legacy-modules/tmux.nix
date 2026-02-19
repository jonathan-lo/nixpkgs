{
  config,
  lib,
  pkgs,
  ...
}:

{
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

    extraConfig = builtins.concatStringsSep "\n" [
      (builtins.readFile ./tmux/keybindings.conf)
      (builtins.readFile ./tmux/options.conf)
      (builtins.readFile ./tmux/vim-navigator.conf)
      (builtins.readFile ./tmux/appearance.conf)
      (builtins.readFile ./tmux/sesh.conf)
    ];

    # theme is set by catppuccin module in theme.nix
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = tmux-thumbs;
      }
    ];
  };
}
