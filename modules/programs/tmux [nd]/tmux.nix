# modules/programs/tmux [nd]/tmux.nix
{ inputs, ... }:
{
  flake.modules.homeManager.tmux = { pkgs, ... }: {
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
        (builtins.readFile ./keybindings.conf)
        (builtins.readFile ./options.conf)
        (builtins.readFile ./vim-navigator.conf)
        (builtins.readFile ./appearance.conf)
        (builtins.readFile ./sesh.conf)
      ];

      # theme is set by catppuccin module in theming.nix
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = tmux-thumbs;
        }
      ];
    };
  };
}
