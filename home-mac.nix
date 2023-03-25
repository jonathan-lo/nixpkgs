{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      du-dust
      fd
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
    ./modules/alacritty.nix
    ./modules/aws.nix
    ./modules/direnv.nix
    ./modules/docker.nix
    ./modules/fzf.nix
    ./modules/go.nix
    ./modules/git.nix
    ./modules/kubernetes.nix
    ./modules/nvim.nix
    ./modules/ops.nix
    ./modules/platform.nix
    ./modules/ripgrep.nix
    ./modules/tmux.nix
    ./modules/zsh.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  settings = {
    alacritty.fontName = "FuraMono Nerd Font Mono";
    zsh.profileExtra = ''
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    '';
    git.email = "jlo@tyro.com";
  };
}
