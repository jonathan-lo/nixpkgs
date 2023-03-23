{ config, pkgs, ... }:

{
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
      yq-go
    ];

    stateVersion = "22.05";
    username = "jlo";
    homeDirectory = "/home/jlo";
  };

  imports = [
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
    zsh.profileExtra = ". /home/jlo/.nix-profile/etc/profile.d/nix.sh";
    git.email = "jchl027@gmail.com";
  };
}
