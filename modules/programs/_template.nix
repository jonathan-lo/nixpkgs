# modules/programs/_template.nix
# Template for new features - copy and rename (remove _ prefix)
#
# Platform scope is set by the `flake.modules.<class>` key a file registers into,
# NOT by the file or directory name:
#   flake.modules.nixos.<name>        = NixOS system module
#   flake.modules.darwin.<name>       = Darwin system module
#   flake.modules.homeManager.<name>  = home-manager module (any OS)
# Register one or more keys to target multiple platforms; delete the stubs you don't need.
#
# The `[..]` suffix seen on directory names elsewhere is a legacy, functionally-inert
# hint the repo is moving away from — import-tree and flake-parts never parse it.
#
{
  inputs,
  lib,
  config,
  ...
}:
{
  # NixOS system configuration
  flake.modules.nixos.featureName =
    { config, pkgs, ... }:
    {
      # NixOS options here
    };

  # Darwin system configuration
  flake.modules.darwin.featureName =
    { config, pkgs, ... }:
    {
      # Darwin options here
    };

  # Home-manager configuration (works on any OS)
  flake.modules.homeManager.featureName =
    { config, pkgs, ... }:
    {
      # Home-manager options here
    };
}
