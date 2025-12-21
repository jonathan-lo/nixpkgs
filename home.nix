{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      act
      bat
      dust
      fd
      fira-code
      unstable.gh
      ghostty
      jq
      just
      mktemp
      neofetch
      nixfmt-rfc-style
      unstable.sesh
      step-cli
      tcpdump
      tree
      ungoogled-chromium
      google-chrome
      yq-go
    ];

    sessionVariables = {
      NVIM_APPNAME = "lazyvim-new";
    };
    stateVersion = "22.05";
    username = "jlo";
  };

  modules.shell.zsh = {
    profileExtra = ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
  };

  imports = [
    ./modules/ai.nix
    ./modules/aws.nix
    ./modules/bitwarden.nix
    ./modules/direnv.nix
    ./modules/docker.nix
    ./modules/editor.nix
    ./modules/fzf.nix
    ./modules/go.nix
    ./modules/google.nix
    ./modules/git.nix
    ./modules/java.nix
    ./modules/kubernetes.nix
    ./modules/node.nix
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
  xdg.configFile.".config/ghostty".text = ''
    theme=catppucin-mocha
  '';
}
