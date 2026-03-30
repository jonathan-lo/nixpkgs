# Quickstart: Private Modules Support

**Branch**: `001-private-modules` | **Date**: 2026-03-30

## Prerequisites

- A private GitHub repository for storing private Nix modules
- SSH access to the private repository configured on your machine
- The main nixpkgs config repo cloned locally

## Setup

### 1. Add the git submodule (one-time, from repo root)

```bash
git submodule add git@github.com:<owner>/<private-repo>.git modules/private
git commit -m "feat: add private modules submodule"
```

### 2. Add private modules

Create module files inside `modules/private/` following the same
conventions as public modules:

```
modules/private/
└── programs/
    └── my-tool [nd]/
        └── my-tool.nix
```

Each `.nix` file self-registers:

```nix
{ ... }:
{
  flake.modules.homeManager.my-tool = {
    # module content
  };
}
```

### 3. Rebuild

```bash
nix run .#write-flake   # Regenerate flake.nix (if needed)
just build              # Dry-run to verify
just apply              # Apply to system
```

## On a New Machine

### With private access

```bash
git clone --recurse-submodules <repo-url>
# or if already cloned:
git submodule update --init
```

### Without private access

```bash
git clone <repo-url>
# Build works — private modules simply don't exist
just apply
```

## Updating Private Modules

```bash
cd modules/private
# make changes, commit, push
cd ../..
git add modules/private
git commit -m "chore: update private modules"
```

## Verification

After setup, confirm discovery works:

```bash
just build   # Should include private module outputs
```

If `modules/private/` is empty or absent, the build still succeeds
with no private module outputs.
