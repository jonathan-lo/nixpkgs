{ options, config, lib, pkgs, ... }:
with lib;
{
  home.packages = with pkgs; [
    dive
    docker-client
  ];

}
