# modules/system/nixpkgs [ND]/nixpkgs.nix
{ inputs, lib, ... }:
let
  allowedUnfree = [
    "claude-code"
    "google-chrome"
    "postman"
    "steam"
    "steam-original"
    "steam-unwrapped"
    "steam-run"
    "terraform"
    "vscode"
  ];

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
}
