{ config, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    defaultCommand = "rg --files";
    tmux.enableShellIntegration = true;
  };
}
