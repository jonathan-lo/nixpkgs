# modules/programs/bitwarden [nd]/bitwarden.nix
{ inputs, ... }:
{
  flake.modules.homeManager.bitwarden =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bitwarden-desktop
        bitwarden-cli
      ];
    };
}
