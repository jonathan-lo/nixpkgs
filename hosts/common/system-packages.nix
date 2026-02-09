{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    coreutils
    findutils
  ];
}
