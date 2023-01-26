{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
        du-dust
        fira-code
        jq
        tcpdump
        yq-go
    ];

    stateVersion = "22.05";
    username = "jlo";
    homeDirectory  = "/home/jlo";
  };

  imports = [
    ./bash.nix
    ./git.nix
    ./nvim.nix
    ./tmux.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  settings = {
    git.email = "jchl027@gmail.com";
  };
}
