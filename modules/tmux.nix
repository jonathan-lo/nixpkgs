{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.settings.tmux;

  extraConfigText = ''
    bind | split-window -h -c '#{pane_current_path}'
    bind - split-window -v -c '#{pane_current_path}'
    bind -T copy-mode-vi v send -X begin-selection
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
    set -s set-clipboard on 
    set-option -g status-position top
    set -ga terminal-overrides ",xterm-256color:Tc:clipboard"
    set -ga terminal-overrides ",alacritty:RGB"
    set-option -g status-interval 5
    set-option -g allow-passthrough on
    set-option -g automatic-rename on
    set-option -g automatic-rename-format '#{b:pane_current_path}'
  '';
in
{
  config.programs.tmux = {
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
    terminal = "alacritty";

    extraConfig = extraConfigText;

    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "battery cpu-usage ram-usage time"
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
        '';
      }
    ];
  };
}
