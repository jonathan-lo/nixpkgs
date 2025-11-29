{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    maven
  ];

  programs.java = {
    enable = false;

  };
  home.file.".ideavimrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nixpkgs/modules/java/.ideavimrc";
}
