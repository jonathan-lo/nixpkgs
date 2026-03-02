# modules/programs/calibre [nd]/calibre.nix
{ inputs, ... }:
{
  flake.modules.homeManager.calibre = { pkgs, ... }: {
    home.packages = with pkgs; [
      calibre
    ];
  };
}
