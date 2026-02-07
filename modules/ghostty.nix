{ config, pkgs, ... }:

{
  # no nix package available for darwin, use brew :(
  # https://github.com/ghostty-org/ghostty/discussions/2824
  programs.ghostty = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
    enableZshIntegration = pkgs.stdenv.hostPlatform.isLinux;

  };
     xdg.configFile."ghostty".source =
         config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/ghostty";
}
