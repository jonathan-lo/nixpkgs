# modules/programs/_template.nix
# Template for new features - copy and rename (remove _ prefix)
#
# Naming convention:
#   feature [N].nix   = NixOS system module
#   feature [D].nix   = Darwin system module
#   feature [n].nix   = NixOS home-manager module
#   feature [d].nix   = Darwin home-manager module
#   feature [nd].nix  = Both home-manager contexts
#   feature [ND].nix  = Both system contexts
#   feature [].nix    = Flake-level only (no system context)
#
{ inputs, lib, config, ... }:
{
  # NixOS system configuration
  flake.modules.nixos.featureName = { config, pkgs, ... }: {
    # NixOS options here
  };

  # Darwin system configuration
  flake.modules.darwin.featureName = { config, pkgs, ... }: {
    # Darwin options here
  };

  # Home-manager configuration (works on any OS)
  flake.modules.homeManager.featureName = { config, pkgs, ... }: {
    # Home-manager options here
  };
}
