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
#    ./bash.nix
    ./fzf.nix
#    ./git.nix
    ./nvim.nix
    ./ripgrep.nix
    ./tmux.nix
    ./zsh-darwin.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

#  settings = {
#    git.email = "jchl027@gmail.com";
#  };
}
