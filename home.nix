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
    ./_legacy-modules/firefox.nix
    ./_legacy-modules/ghostty
    ./_legacy-modules/java
    ./_legacy-modules/lazyvim
    ./_legacy-modules/theme.nix
    ./_legacy-modules/tmux.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide.enable = true;
}
