{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./private/darwin/default.nix
  ];
}
