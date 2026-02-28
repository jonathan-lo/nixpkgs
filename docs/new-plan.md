# Plan: Migrate to Dendritic-Tools Pattern

Adopt the dendritic-tools architecture from the source repo, including `flake-file` for auto-generated flake.nix.

## Pre-Migration: Capture Baseline

**Run BEFORE any changes to capture current derivation paths:**
```bash
# Darwin system
nix derivation show .#darwinConfigurations.Jonathans-MacBook-Pro.system 2>/dev/null | jq -r 'keys[0]' > /tmp/darwin-drv-baseline.txt

# NixOS system
nix derivation show .#nixosConfigurations.budu.config.system.build.toplevel 2>/dev/null | jq -r 'keys[0]' > /tmp/nixos-drv-baseline.txt

# Home configurations
nix derivation show .#homeConfigurations.DESKTOP-7RRDPPB.activationPackage 2>/dev/null | jq -r 'keys[0]' > /tmp/hm-desktop-baseline.txt
nix derivation show .#homeConfigurations.LAPTOP-GIVRN79I.activationPackage 2>/dev/null | jq -r 'keys[0]' > /tmp/hm-laptop-baseline.txt
```

---

## Overview

**Current:** Manual flake.nix with import-tree
**Target:** Auto-generated flake.nix via flake-file with modular input declarations

**Key Workflow Change:** After this migration, you'll edit modules and run `nix run .#write-flake` to regenerate flake.nix (marked DO-NOT-EDIT).

---

## Phase 1: Add Core Modules

### Step 1.1: Add `factory.nix`
**File:** `modules/nix/flake-parts []/factory.nix`
- Copy from source (no changes)

### Step 1.2: Replace `lib.nix`
**File:** `modules/nix/flake-parts []/lib.nix`
- Replace placeholder with source version
- **Adapt:** `inputs.nix-darwin` → `inputs.darwin`

### Step 1.3: Add `darwinConfigurations-fix.nix`
**File:** `modules/nix/flake-parts []/darwinConfigurations-fix.nix`
- Copy from source (no changes)
- Required for flake-parts to recognize darwinConfigurations

### Step 1.4: Add `dendritic-tools.nix`
**File:** `modules/nix/flake-parts []/dendritic-tools.nix`
- Copy from source with adaptations:
  - Add `nixpkgs` input declaration (required base)
  - Adjust systems list to match current config

### Phase 1 Verification
```bash
nix flake check

# Compare derivations to baseline (should be identical - no functional changes)
nix derivation show .#darwinConfigurations.Jonathans-MacBook-Pro.system 2>/dev/null | jq -r 'keys[0]' > /tmp/darwin-drv-p1.txt
nix derivation show .#nixosConfigurations.budu.config.system.build.toplevel 2>/dev/null | jq -r 'keys[0]' > /tmp/nixos-drv-p1.txt
nix derivation show .#homeConfigurations.DESKTOP-7RRDPPB.activationPackage 2>/dev/null | jq -r 'keys[0]' > /tmp/hm-desktop-p1.txt

diff /tmp/darwin-drv-baseline.txt /tmp/darwin-drv-p1.txt && echo "Darwin: OK"
diff /tmp/nixos-drv-baseline.txt /tmp/nixos-drv-p1.txt && echo "NixOS: OK"
diff /tmp/hm-desktop-baseline.txt /tmp/hm-desktop-p1.txt && echo "HM: OK"
```

**If verification fails:** Stop and investigate before proceeding.

---

## Phase 2: Migrate Existing Inputs to Modules

Move inputs from root flake.nix into tool-specific `flake-parts.nix` files.

### Step 2.1: Create `nixpkgs` module
**New file:** `modules/nix/tools/nixpkgs []/flake-parts.nix`
```nix
{
  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };
}
```

### Step 2.2: Create `darwin` module inputs
**New file:** `modules/nix/tools/darwin [D]/flake-parts.nix`
```nix
{
  flake-file.inputs = {
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

### Step 2.3: Update `home-manager` module
**File:** `modules/nix/tools/home-manager [ND]/flake-parts.nix` (create new)
- Add `flake-file.inputs` declaration
- Import home-manager flake module

### Step 2.4: Update `determinate` modules
**Files:** Both `[N]` and `[D]` variants
- Add `flake-file.inputs` with determinate URL

### Step 2.5: Create `catppuccin` module
**New file:** `modules/programs/theming [nd]/flake-parts.nix`
```nix
{
  flake-file.inputs.catppuccin.url = "github:catppuccin/nix";
}
```

### Phase 2 Verification
```bash
nix flake check

# Compare derivations to baseline (should be identical - inputs not yet regenerated)
nix derivation show .#darwinConfigurations.Jonathans-MacBook-Pro.system 2>/dev/null | jq -r 'keys[0]' > /tmp/darwin-drv-p2.txt
nix derivation show .#nixosConfigurations.budu.config.system.build.toplevel 2>/dev/null | jq -r 'keys[0]' > /tmp/nixos-drv-p2.txt
nix derivation show .#homeConfigurations.DESKTOP-7RRDPPB.activationPackage 2>/dev/null | jq -r 'keys[0]' > /tmp/hm-desktop-p2.txt

diff /tmp/darwin-drv-baseline.txt /tmp/darwin-drv-p2.txt && echo "Darwin: OK"
diff /tmp/nixos-drv-baseline.txt /tmp/nixos-drv-p2.txt && echo "NixOS: OK"
diff /tmp/hm-desktop-baseline.txt /tmp/hm-desktop-p2.txt && echo "HM: OK"
```

**If verification fails:** Stop and investigate before proceeding.

---

## Phase 3: Migrate Host Configurations

### Step 3.1: Update macbook host
**File:** `modules/hosts/macbook [D]/flake-parts.nix` (create)
- Add `flake.darwinConfigurations` using lib helper
- Reference: `inputs.self.lib.mkDarwin "aarch64-darwin" "macbook"`

### Step 3.2: Update budu host
**File:** `modules/hosts/budu [N]/flake-parts.nix` (create)
- Add `flake.nixosConfigurations` using lib helper

### Step 3.3: Migrate standalone home configurations
- Convert `homeConfigurations.DESKTOP-7RRDPPB` and `LAPTOP-GIVRN79I`
- Create host modules or use `mkHomeManager` helper

### Phase 3 Verification
```bash
nix flake check

# Compare derivations to baseline (should be identical - just restructured)
nix derivation show .#darwinConfigurations.Jonathans-MacBook-Pro.system 2>/dev/null | jq -r 'keys[0]' > /tmp/darwin-drv-p3.txt
nix derivation show .#nixosConfigurations.budu.config.system.build.toplevel 2>/dev/null | jq -r 'keys[0]' > /tmp/nixos-drv-p3.txt
nix derivation show .#homeConfigurations.DESKTOP-7RRDPPB.activationPackage 2>/dev/null | jq -r 'keys[0]' > /tmp/hm-desktop-p3.txt

diff /tmp/darwin-drv-baseline.txt /tmp/darwin-drv-p3.txt && echo "Darwin: OK"
diff /tmp/nixos-drv-baseline.txt /tmp/nixos-drv-p3.txt && echo "NixOS: OK"
diff /tmp/hm-desktop-baseline.txt /tmp/hm-desktop-p3.txt && echo "HM: OK"
```

**If verification fails:** Stop and investigate before proceeding.

---

## Phase 4: Generate New flake.nix

### Step 4.1: Bootstrap flake-file
Temporarily add flake-file input to current flake.nix:
```nix
flake-file.url = "github:vic/flake-file";
```

### Step 4.2: Generate flake.nix
```bash
nix run .#write-flake
```

### Step 4.3: Verify generated flake.nix
- Check all inputs are present
- Verify outputs structure matches expected

### Phase 4 Verification
```bash
nix flake check

# This is the critical phase - flake.nix is now auto-generated
nix derivation show .#darwinConfigurations.Jonathans-MacBook-Pro.system 2>/dev/null | jq -r 'keys[0]' > /tmp/darwin-drv-p4.txt
nix derivation show .#nixosConfigurations.budu.config.system.build.toplevel 2>/dev/null | jq -r 'keys[0]' > /tmp/nixos-drv-p4.txt
nix derivation show .#homeConfigurations.DESKTOP-7RRDPPB.activationPackage 2>/dev/null | jq -r 'keys[0]' > /tmp/hm-desktop-p4.txt

diff /tmp/darwin-drv-baseline.txt /tmp/darwin-drv-p4.txt && echo "Darwin: OK"
diff /tmp/nixos-drv-baseline.txt /tmp/nixos-drv-p4.txt && echo "NixOS: OK"
diff /tmp/hm-desktop-baseline.txt /tmp/hm-desktop-p4.txt && echo "HM: OK"
```

**If verification fails:** This is expected if inputs are reordered. Check troubleshooting section.

---

## Phase 5: Final Verification and Commit

### Step 5.1: Full system rebuild
```bash
darwin-rebuild build --flake .
nixos-rebuild build --flake .#budu
```

### Step 5.2: Final derivation comparison to baseline
```bash
# Final comparison against original baseline
diff /tmp/darwin-drv-baseline.txt /tmp/darwin-drv-p4.txt
diff /tmp/nixos-drv-baseline.txt /tmp/nixos-drv-p4.txt
diff /tmp/hm-desktop-baseline.txt /tmp/hm-desktop-p4.txt
```

### Step 5.3: Commit
```bash
git add -A
git commit -m "Migrate to dendritic-tools pattern with flake-file"
```

---

## Files Summary

| File | Action |
|------|--------|
| `modules/nix/flake-parts []/factory.nix` | Create |
| `modules/nix/flake-parts []/lib.nix` | Replace |
| `modules/nix/flake-parts []/darwinConfigurations-fix.nix` | Create |
| `modules/nix/flake-parts []/dendritic-tools.nix` | Create |
| `modules/nix/tools/nixpkgs []/flake-parts.nix` | Create |
| `modules/nix/tools/darwin [D]/flake-parts.nix` | Create |
| `modules/nix/tools/home-manager [ND]/flake-parts.nix` | Create |
| `modules/nix/tools/determinate [N]/flake-parts.nix` | Create |
| `modules/nix/tools/determinate [D]/flake-parts.nix` | Create |
| `modules/programs/theming [nd]/flake-parts.nix` | Create |
| `modules/hosts/macbook [D]/flake-parts.nix` | Create |
| `modules/hosts/budu [N]/flake-parts.nix` | Create |
| `flake.nix` | Auto-generated (DO-NOT-EDIT) |

---

## New Workflow After Migration

1. Edit modules in `modules/` directory
2. Run `nix run .#write-flake` to regenerate flake.nix
3. Run `nix flake check` to verify
4. Rebuild: `darwin-rebuild switch --flake .`

---

## Potential Issues

1. **Regeneration discipline** - Must run `write-flake` after module changes
2. **Input conflicts** - If two modules declare same input differently
3. **Directory brackets** - Some tools may struggle with `[D]`, `[N]` in paths

---

## Troubleshooting: If Derivations Differ

If derivations don't match after migration:

```bash
# Compare derivation inputs
nix derivation show <old-drv> > /tmp/old.json
nix derivation show <new-drv> > /tmp/new.json
diff /tmp/old.json /tmp/new.json

# Check specific differences
nix why-depends .#darwinConfigurations.Jonathans-MacBook-Pro.system <different-package>

# List closure differences
nix path-info -r <old-drv> | sort > /tmp/old-closure.txt
nix path-info -r <new-drv> | sort > /tmp/new-closure.txt
diff /tmp/old-closure.txt /tmp/new-closure.txt
```

Common causes:
- Different nixpkgs input URLs/revisions
- Missing `follows` declarations
- Changed module import order affecting option merging
