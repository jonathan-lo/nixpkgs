{
  lib,
  pkgs,
  ...
}:
with lib;
{
  home.packages = with pkgs; [
    unstable.dive
    docker-client
  ];
}
