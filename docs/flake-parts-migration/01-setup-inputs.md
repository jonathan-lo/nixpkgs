# Phase 1: Setup Inputs

## Objective

Add flake-parts and import-tree as flake inputs without breaking existing functionality.

## Steps

### 1.1 Add New Inputs

Add these to your `flake.nix` inputs:

```nix
{
  inputs = {
    # ... existing inputs ...

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    import-tree = {
      url = "github:vic/import-tree";
      flake = false;  # It's a library, not a flake
    };

    # Optional: auto-generate flake.nix from modules
    flake-file = {
      url = "github:vic/flake-file";
    };
  };
}
```

### 1.2 Update Lock File

```bash
nix flake update flake-parts import-tree
# or to update everything:
nix flake update
```

### 1.3 Verify Inputs

```bash
nix flake metadata
```

Should show flake-parts and import-tree in the inputs list.

## Minimal Integration Test

Wrap existing outputs in `mkFlake` without changing behavior:

```nix
outputs =
  inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    catppuccin,
    darwin,
    determinate,
    flake-parts,  # Add this
    home-manager,
    ...
  }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    # Supported systems (required by flake-parts)
    systems = [ "x86_64-linux" "aarch64-darwin" ];

    # Put all existing outputs in `flake` attribute
    flake =
      let
        overlay = final: prev: {
          unstable = import inputs.nixpkgs-unstable {
            system = prev.stdenv.hostPlatform.system;
            config.allowUnfree = true;
          };
        };
        overlays = [ overlay ];
        nixPkgsConfig = {
          inherit overlays;
          config.allowUnfree = true;
        };
      in
      {
        # All existing configurations go here unchanged
        nixosConfigurations = {
          "budu" = nixpkgs.lib.nixosSystem {
            # ... existing config ...
          };
        };

        darwinConfigurations = {
          # ... existing config ...
        };

        homeConfigurations = {
          # ... existing config ...
        };
      };

    # Empty for now, will populate later
    perSystem = { pkgs, ... }: { };
  };
```

### 1.4 Validation

```bash
# Test NixOS build
nixos-rebuild dry-build --flake .#budu

# Test Darwin build
darwin-rebuild build --flake .#Jonathans-MacBook-Pro

# Test home-manager
home-manager build --flake .#DESKTOP-7RRDPPB
```

All should work identically to before.

## Understanding mkFlake

```nix
flake-parts.lib.mkFlake { inherit inputs; } {
  # Top-level options:
  systems = [ ... ];           # Required: which systems to build for
  imports = [ ... ];           # Optional: import other flake-parts modules
  flake = { ... };             # System-independent outputs (nixosConfigurations, etc.)
  perSystem = { ... };         # Per-system outputs (packages, devShells, etc.)
}
```

The `flake` attribute is where system-independent outputs go. This is a pass-through for now but will be replaced by auto-generated outputs later.

## Files Changed

- `flake.nix` - Added inputs, wrapped outputs in mkFlake

## Checkpoint

At this point:
- [x] flake-parts and import-tree are available as inputs
- [x] Existing configurations still build
- [x] Ready to create module structure

## Next

[02-modules-structure.md](./02-modules-structure.md) - Create the directory structure for features
