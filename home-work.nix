{ config, pkgs, ... }:

{
  imports = [
    ./home.nix
    ./private/darwin.nix
  ];
}
