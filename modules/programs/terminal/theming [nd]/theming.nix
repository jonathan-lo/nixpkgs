# modules/programs/terminal/theming [nd]/theming.nix
{ inputs, ... }:
{
  # Home-manager theming for any OS
  flake.modules.homeManager.theming = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    catppuccin = {
      enable = true;
      flavor = "mocha";
      btop.enable = true;
      ghostty.enable = false; # managed via dotfiles

      # Show the window name (#W) in the status bar instead of catppuccin's
      # default of the pane title (#T). The pane title is whatever the program
      # in the pane last wrote with an OSC 0/2 escape, so it is either stale
      # mojibake from a title that was never set or a TUI's live spinner text --
      # that is the garbled window names. #W is tmux's own name, driven by
      # automatic-rename-format in the tmux module.
      #
      # This has to go in extraConfig rather than the tmux module's config
      # files: catppuccin bakes @catppuccin_window_text into
      # window-status-format when its run-shell fires, and home-manager emits
      # this block just above that run-shell. Anything set afterwards is
      # ignored.
      tmux.extraConfig = ''
        set -g @catppuccin_window_text " #W"
        set -g @catppuccin_window_current_text " #W"
      '';
    };
  };
}
