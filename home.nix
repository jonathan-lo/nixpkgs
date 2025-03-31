{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      act
      bat
      du-dust
      fd
      fira-code
      unstable.gh
      jq
      mktemp
      neofetch
      nixpkgs-fmt
      unstable.sesh
      step-cli
      tcpdump
      tree
      yq-go
    ];

    stateVersion = "22.05";
    username = "jlo";
  };


  modules.shell.zsh = {
    profileExtra = ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
  };

  imports = [
    ./modules/alacritty.nix
    ./modules/aws.nix
    ./modules/direnv.nix
    ./modules/docker.nix
    ./modules/editor.nix
    ./modules/fzf.nix
    ./modules/go.nix
    ./modules/git.nix
    ./modules/java.nix
#    ./modules/kubernetes.nix
    ./modules/lazyvim
    ./modules/ops.nix
    ./modules/platform.nix
    ./modules/ripgrep.nix
    ./modules/tmux.nix
    ./modules/wezterm.nix
    ./modules/zsh.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide.enable = true;
}
