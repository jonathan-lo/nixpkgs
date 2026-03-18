# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
just apply          # Rebuild system (darwin-rebuild/nixos-rebuild/home-manager depending on OS)
just build          # Dry-run build on macOS
just lint           # Format all .nix files with nixfmt
just update         # Update flake.lock
nix run .#write-flake  # Regenerate flake.nix from modules (DO NOT edit flake.nix directly)
```

Use `/nix-drv-check` to verify staged changes produce an identical derivation (refactor safety check).

## Architecture

This is a multi-platform Nix configuration repo managing macOS (nix-darwin), NixOS, and WSL (standalone home-manager) from a single flake.

### Core mechanism

`flake.nix` is **auto-generated** — do not edit it. The source of truth is the `modules/` directory. All `.nix` files are auto-discovered by [import-tree](https://github.com/vic/import-tree) and composed via [flake-parts](https://flake.parts).

Each module file is a flake-parts module that self-registers its outputs (e.g., `flake.modules.homeManager.git = { ... }`). There is no central index or imports list — just drop a `.nix` file in `modules/` and it's included.

### Directory bracket notation

Directory names use `[LETTERS]` to indicate which platform layers they contribute to:

| Bracket | Meaning |
|---------|---------|
| `[D]` | `flake.modules.darwin.*` |
| `[N]` | `flake.modules.nixos.*` |
| `[ND]` | Both darwin and nixos modules |
| `[n]` | homeManager module (used by nixos/darwin/WSL) |
| `[nd]` | homeManager module (same as `[n]`) |
| `[d]` | darwinConfigurations |
| `[]` | Flake-parts infrastructure (no platform output) |

### Factory pattern

`modules/factory/user [ND]/user.nix` defines `self.factory.user` — a function that generates cross-platform user config (nixos + darwin + home-manager) from a username and admin flag. Used in user files like `modules/users/jlo [ND]/jlo.nix` via `self.factory.user "jlo" true`.

### Library helpers

`modules/nix/flake-parts []/lib.nix` provides `self.lib.mkNixos`, `self.lib.mkDarwin`, `self.lib.mkHomeManager` for creating system/home configurations in host files.

### Host configurations

- **macOS:** `modules/hosts/darwin [D]/nc/` → `darwinConfigurations.Jonathans-MacBook-Pro` (aarch64-darwin)
- **NixOS:** `modules/hosts/linux [N]/budu/` → `nixosConfigurations.budu` (x86_64-linux)
- **WSL:** `modules/hosts/wsl []/` → `homeConfigurations.DESKTOP-*` (standalone home-manager, no system config)

### Module composition

User files (e.g., `jlo.nix`) import homeManager modules by name:
```nix
imports = with self.modules.homeManager; [ browsers git lazyvim ... ];
```
These names correspond to `flake.modules.homeManager.<name>` declared in program modules.

### Overlays

`modules/nix/tools/nixpkgs [ND]/nixpkgs.nix` sets up an overlay making `nixpkgs-unstable` packages available as `pkgs.unstable.*`.

