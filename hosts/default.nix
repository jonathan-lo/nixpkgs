{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # base cli
    coreutils
    findutils

    # utils
    dust
    fd
    fira-code
    gnumake
    mktemp
    neofetch
    tree
  ];
}
