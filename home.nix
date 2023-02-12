{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
        du-dust
        fira-code
        unstable.gh
        jq
        nixpkgs-fmt
        step-cli
        tcpdump
        yq-go
    ];

    stateVersion = "22.05";
    username = "jlo";
    homeDirectory  = "/home/jlo";
  };

  imports = [
    ./fzf.nix
    ./go.nix
    ./git.nix
    ./kubernetes.nix
    ./nvim.nix
    ./ops.nix
    ./platform.nix
    ./ripgrep.nix
    ./tmux.nix
    ./zsh.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  settings = {
    git.email = "jchl027@gmail.com";
  };
}
