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
    homeDirectory = "/Users/jlo";
  };

  imports = [
    ./alacritty.nix
    ./aws.nix
    ./docker.nix
    ./fzf.nix
    ./go.nix
    ./gpg.nix
    #    ./git.nix
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
    #    git.email = "jchl027@gmail.com";

    zsh.profileExtra = ''
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      export NIX_SSL_CERT_FILE=/Library/Certificates/allcerts.pem
      export GPG_TTY="$(tty)"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

      gpgconf --launch pg-agent
      gpg-connect-agent updatestartuptty /bye > /dev/null
    '';
  };
}
