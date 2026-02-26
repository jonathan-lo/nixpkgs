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
    ./_legacy-modules/lazyvim
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zoxide.enable = true;
}
