{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      jq
      just
      nixfmt-rfc-style
      postman
      unstable.sesh
      step-cli
      tcpdump
      yq-go
    ];

    sessionVariables = {
      NVIM_APPNAME = "lazyvim-new";
    };
    stateVersion = "22.05";
    username = "jlo";
  };

  imports = [
    ./_legacy-modules/bitwarden.nix
    ./_legacy-modules/calibre.nix
    ./_legacy-modules/docker.nix
    ./_legacy-modules/firefox.nix
    ./_legacy-modules/git.nix
    ./_legacy-modules/ghostty
    ./_legacy-modules/java
    ./_legacy-modules/lazyvim
    ./_legacy-modules/ripgrep.nix
    ./_legacy-modules/theme.nix
    ./_legacy-modules/tmux.nix
    ./_legacy-modules/zsh.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide.enable = true;
}
