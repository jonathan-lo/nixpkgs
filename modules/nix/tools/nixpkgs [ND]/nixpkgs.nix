# modules/system/nixpkgs [ND]/nixpkgs.nix
{
  config,
  inputs,
  lib,
  ...
}:
let
  allowedUnfree = config.flake.allowedUnfreePackages;
  unfreePredicate = pkg: builtins.elem (lib.getName pkg) allowedUnfree;

  # Overlay to add unstable packages
  unstableOverlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfreePredicate = unfreePredicate;
    };
  };
in
{
  options.flake.allowedUnfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Package names to allow in the unfree predicate.";
  };

  config = {
    # NixOS system-level nixpkgs config
    flake.modules.nixos.nixpkgsConfig =
      { ... }:
      {
        nixpkgs.overlays = [ unstableOverlay ];
        nixpkgs.config.allowUnfreePredicate = unfreePredicate;
      };

    # Darwin system-level nixpkgs config
    flake.modules.darwin.nixpkgsConfig =
      { ... }:
      {
        nixpkgs.overlays = [ unstableOverlay ];
        nixpkgs.config.allowUnfreePredicate = unfreePredicate;
      };
  };
}
