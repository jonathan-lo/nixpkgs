# Flake-Parts Dendritic Migration Overview

## Goal

Migrate from a top-down host-centric flake to a bottom-up feature-centric architecture using flake-parts and the dendritic design pattern.

## Current State

```
flake.nix (monolithic)
├── nixosConfigurations.budu
├── darwinConfigurations.Jonathans-MacBook-Pro
├── homeConfigurations.DESKTOP-7RRDPPB
└── homeConfigurations.LAPTOP-GIVRN79I
```

- Settings defined inline or in host-specific files
- Repeated patterns (catppuccin, home-manager setup, overlays)
- Adding features requires editing multiple host files

## Target State

```
flake.nix (minimal, auto-generated)
modules/
├── nix/
│   └── flake-parts/        # Framework configuration
├── programs/
│   ├── theming/            # Catppuccin for all contexts
│   ├── shell/              # Shell config (zsh, bash, etc.)
│   └── ...
├── services/
│   └── ...
├── system/
│   ├── nixpkgs/            # Overlays, allowUnfree
│   └── ...
├── users/
│   └── jlo/                # User-specific settings
└── hosts/
    ├── budu/               # NixOS host
    ├── macbook/            # Darwin host
    └── wsl/                # Standalone home-manager
```

- Features defined once, composed by hosts
- Single line to add/remove a feature from a host
- Clear separation of concerns

## Migration Phases

| Phase | Document | Description |
|-------|----------|-------------|
| 1 | [01-setup-inputs.md](./01-setup-inputs.md) | Add flake-parts, import-tree to inputs |
| 2 | [02-modules-structure.md](./02-modules-structure.md) | Create directory structure |
| 3 | [03-feature-extraction.md](./03-feature-extraction.md) | Extract repeated patterns into features |
| 4 | [04-host-conversion.md](./04-host-conversion.md) | Convert hosts to dendritic pattern |
| 5 | [05-helpers-and-utilities.md](./05-helpers-and-utilities.md) | Create mkNixos, mkDarwin helpers |
| 6 | [06-testing-and-validation.md](./06-testing-and-validation.md) | Validate the migration |

## Key Concepts

### Module Classes

| Class | Context | Example Use |
|-------|---------|-------------|
| `nixos` | NixOS system configuration | systemd services, boot, networking |
| `darwin` | nix-darwin system configuration | macOS defaults, homebrew |
| `homeManager` | home-manager (any OS) | dotfiles, user programs |
| `generic` | Cross-context utilities | Shared lib functions |

### Naming Convention

Files/directories use brackets to indicate supported contexts:
- `[N]` = NixOS system
- `[D]` = Darwin system
- `[n]` = NixOS home-manager
- `[d]` = Darwin home-manager
- `[nd]` = Both home-manager contexts
- `[ND]` = Both system contexts
- `[]` = Framework/flake-level only

Example: `shell [nd].nix` provides home-manager config for both Linux and macOS.

## Dependencies

| Input | Purpose | URL |
|-------|---------|-----|
| flake-parts | Module system for flakes | `github:hercules-ci/flake-parts` |
| import-tree | Auto-import all .nix files | `github:vic/import-tree` |
| flake-file | Auto-generate flake.nix (optional) | `github:vic/flake-file` |

## Risks and Mitigations

| Risk | Mitigation |
|------|------------|
| Breaking existing configs | Test each phase with `nixos-rebuild dry-run` |
| Learning curve | Follow patterns from dendritic-design repo |
| Import conflicts | Use `_prefix` to exclude files from auto-import |
| Debugging difficulty | Keep host modules simple, logic in features |

## Success Criteria

- [ ] All hosts build successfully
- [ ] No repeated code blocks across hosts
- [ ] Adding a new feature = 1 file + 1 import line
- [ ] Clear ownership: each setting lives in exactly one feature
