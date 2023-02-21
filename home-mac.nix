{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

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
      tree
      yq-go
    ];

    stateVersion = "22.05";
    username = "jlo";
    homeDirectory = "/Users/jlo";
  };

  imports = [
    ./alacritty.nix
    ./aws.nix
    ./docker.nix
    ./fzf.nix
    ./go.nix
    ./gpg.nix
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
    alacritty.fontName = "Fira Code";
    zsh.profileExtra = ''
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    '';
    git.email = "jlo@tyro.com";
  };
}
