{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
        du-dust
        fira-code
        jq
    ];

    stateVersion = "22.05";
    username = "jlo";
    homeDirectory  = "/Users/jlo";
  };

  imports = [
    ./alacritty.nix
    ./fzf.nix
    ./go.nix
#    ./git.nix
    ./homebrew.nix
    ./kubernetes.nix
    ./nvim.nix
    ./platform.nix
    ./ripgrep.nix
    ./tmux.nix
    ./zsh-darwin.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  settings = {
     alacritty.fontName = "Fira Code";
#    git.email = "jchl027@gmail.com";
  };
}
