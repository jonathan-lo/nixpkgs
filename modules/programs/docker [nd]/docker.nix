# modules/programs/docker [nd]/docker.nix
{ inputs, ... }:
{
  flake.modules.nixos.docker = {
    virtualisation.docker.enable = true;
  };

  flake.modules.homeManager.docker = { pkgs, ... }: {
    home.packages = with pkgs; [
      unstable.dive
      docker-client
    ];
  };
}
