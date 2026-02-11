{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      jq
      just
      nixfmt-rfc-style
      postman
      unstable.sesh
      step-cli
      tcpdump
      yq-go
    ];

    sessionVariables = {
      NVIM_APPNAME = "lazyvim-new";
    };
    stateVersion = "22.05";
    username = "jlo";
  };

  imports = [
    ./modules/ai.nix
    ./modules/aws.nix
    ./modules/bash.nix
    ./modules/bat.nix
    ./modules/btop.nix
    ./modules/bitwarden.nix
    ./modules/calibre.nix
    ./modules/direnv.nix
    ./modules/docker.nix
    ./modules/editor.nix
    ./modules/firefox.nix
    ./modules/fzf.nix
    ./modules/go.nix
    ./modules/gcp.nix
    ./modules/git.nix
    ./modules/ghostty
    ./modules/java
    ./modules/kubernetes.nix
    ./modules/node.nix
    ./modules/lazyvim
    ./modules/ops.nix
    ./modules/platform.nix
    ./modules/ripgrep.nix
    ./modules/theme.nix
    ./modules/tmux.nix
    ./modules/zsh.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide.enable = true;
}
