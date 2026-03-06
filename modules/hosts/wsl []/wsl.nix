# Standalone home-manager configurations for WSL hosts
{ inputs, config, ... }:
let
  inherit (inputs) nixpkgs home-manager catppuccin;

  # Shared WSL home configuration
  mkWslHome = name: home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    modules = [
      {
        home = {
          stateVersion = "22.05";
          username = "jlo";
        };
      }
      catppuccin.homeModules.catppuccin
    ];
  };
in
{
  flake.homeConfigurations = {
    "DESKTOP-7RRDPPB" = mkWslHome "DESKTOP-7RRDPPB";
    "LAPTOP-GIVRN79I" = mkWslHome "LAPTOP-GIVRN79I";
  };
}
