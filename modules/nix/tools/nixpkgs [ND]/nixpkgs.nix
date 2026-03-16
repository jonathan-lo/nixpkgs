# modules/system/nixpkgs [ND]/nixpkgs.nix
{ inputs, ... }:
let
  # Overlay to add unstable packages
  unstableOverlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
in
{
  # NixOS system-level nixpkgs config
  flake.modules.nixos.nixpkgsConfig =
    { ... }:
    {
      nixpkgs.overlays = [ unstableOverlay ];
      nixpkgs.config.allowUnfree = true;
    };

  # Darwin system-level nixpkgs config
  flake.modules.darwin.nixpkgsConfig =
    { ... }:
    {
      nixpkgs.overlays = [ unstableOverlay ];
      nixpkgs.config.allowUnfree = true;
    };
}
