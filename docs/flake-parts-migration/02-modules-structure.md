# Phase 2: Create Modules Structure

## Objective

Set up the directory structure for dendritic modules and configure import-tree.

## Directory Structure

Create this structure:

```
modules/
├── nix/
│   └── flake-parts []/
│       ├── imports.nix         # import-tree setup
│       ├── lib.nix             # Helper functions (mkNixos, mkDarwin, etc.)
│       └── systems.nix         # Supported systems list
├── system/
│   └── nixpkgs [ND]/
│       └── nixpkgs.nix         # Overlays, allowUnfree
├── programs/
│   └── _template.nix           # Template for new features (excluded by _)
├── services/
│   └── .gitkeep
├── users/
│   └── jlo [nd]/
│       └── jlo.nix             # User jlo's home-manager settings
└── hosts/
    ├── budu [N]/
    │   └── flake-parts.nix     # Host definition
    ├── macbook [D]/
    │   └── flake-parts.nix
    └── wsl [n]/
        └── flake-parts.nix
```

## Step-by-Step Creation

### 2.1 Create Directory Structure

```bash
mkdir -p modules/nix/flake-parts\ \[\]
mkdir -p modules/system/nixpkgs\ \[ND\]
mkdir -p modules/programs
mkdir -p modules/services
mkdir -p modules/users/jlo\ \[nd\]
mkdir -p modules/hosts/budu\ \[N\]
mkdir -p modules/hosts/macbook\ \[D\]
mkdir -p modules/hosts/wsl\ \[n\]
```

Note: The brackets in directory names are metadata for humans. `import-tree` imports everything regardless of naming.

### 2.2 Create Framework Files

#### `modules/nix/flake-parts []/imports.nix`

This bootstraps import-tree:

```nix
# modules/nix/flake-parts []/imports.nix
{ inputs, ... }:
let
  import-tree = import inputs.import-tree;
in
{
  imports = [
    # Import all .nix files in modules/ recursively
    # Files starting with _ are excluded
    (import-tree ../../..)
  ];
}
```

#### `modules/nix/flake-parts []/systems.nix`

```nix
# modules/nix/flake-parts []/systems.nix
{ ... }:
{
  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
}
```

#### `modules/nix/flake-parts []/lib.nix`

Helper functions (detailed in Phase 5):

```nix
# modules/nix/flake-parts []/lib.nix
{ inputs, lib, ... }:
{
  # Will contain mkNixos, mkDarwin, mkHome helpers
  # Placeholder for now
  flake.lib = { };
}
```

### 2.3 Create Feature Template

#### `modules/programs/_template.nix`

```nix
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
```

### 2.4 Update flake.nix for import-tree

```nix
{
  inputs = {
    # ... all inputs ...
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # This recursively imports all .nix files in modules/
        (import inputs.import-tree ./modules)
      ];

      # systems is now defined in modules/nix/flake-parts []/systems.nix

      # Keep existing flake outputs for now (will migrate incrementally)
      flake = {
        # ... existing nixosConfigurations, etc. ...
      };
    };
}
```

## Verification

### Check import-tree Works

```bash
# This should not error
nix eval .#nixosConfigurations.budu.config.system.stateVersion
```

### Check Module Discovery

Add a test module to verify imports work:

```nix
# modules/_test.nix (will be excluded from import)
{ ... }:
{
  # Temporarily rename to test.nix to verify import-tree finds it
  flake.debug = "import-tree is working";
}
```

```bash
nix eval .#debug
# Should output: "import-tree is working"
```

Then delete or rename back to `_test.nix`.

## Understanding import-tree

`import-tree` recursively finds all `.nix` files and imports them as flake-parts modules.

**Exclusions:**
- Files/directories starting with `_` are excluded
- Files named `flake.nix` are excluded
- Hidden files (starting with `.`) are excluded

**Why this matters:**
- Put work-in-progress in `_wip/` or `_feature.nix`
- Data files that shouldn't be imported: `_data/hosts.json`
- Templates: `_template.nix`

## Files Created

```
modules/
├── nix/flake-parts []/
│   ├── imports.nix
│   ├── lib.nix
│   └── systems.nix
├── programs/_template.nix
├── services/.gitkeep
├── system/nixpkgs [ND]/.gitkeep
├── users/jlo [nd]/.gitkeep
└── hosts/
    ├── budu [N]/.gitkeep
    ├── macbook [D]/.gitkeep
    └── wsl [n]/.gitkeep
```

## Checkpoint

At this point:
- [x] Directory structure exists
- [x] import-tree is configured
- [x] Framework files are in place
- [x] Existing configs still work (unchanged in `flake` attr)

## Next

[03-feature-extraction.md](./03-feature-extraction.md) - Extract common patterns into feature modules
