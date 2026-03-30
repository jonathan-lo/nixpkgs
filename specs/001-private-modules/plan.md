# Implementation Plan: Private Modules Support

**Branch**: `001-private-modules` | **Date**: 2026-03-30 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-private-modules/spec.md`

## Summary

Add support for private Nix configuration modules stored in a git
submodule at `modules/private/`, automatically discovered by the
existing import-tree mechanism. The build MUST gracefully degrade when
the submodule is absent or uninitialized.

## Technical Context

**Language/Version**: Nix (flake-based, using flake-parts + import-tree)
**Primary Dependencies**: import-tree, flake-parts, flake-file
**Storage**: N/A (file-based Nix modules)
**Testing**: `just build` (dry-run), `just apply` (live rebuild), `/nix-drv-check` (derivation equivalence)
**Target Platform**: macOS (aarch64-darwin), NixOS (x86_64-linux), WSL (x86_64-linux home-manager)
**Project Type**: System configuration repository
**Performance Goals**: N/A (build-time only)
**Constraints**: Zero impact on existing module discovery; graceful degradation when submodule absent
**Scale/Scope**: Single private modules directory; one git submodule reference

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Reproducibility First | PASS | Git submodule pins exact commit SHA; no impure operations |
| II. Modularity & Composability | PASS | Private modules self-register via same flake-parts interfaces; no central imports change |
| III. Cross-Platform Parity | PASS | Private modules use same bracket notation for platform scoping |
| IV. Simplicity & YAGNI | PASS | No new abstractions — leverages existing import-tree discovery; submodule is simplest mechanism |
| V. Build Safety | PASS | `just build` validates; graceful degradation when absent; `write-flake` unaffected |

No violations. Complexity Tracking section not needed.

## Project Structure

### Documentation (this feature)

```text
specs/001-private-modules/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks)
```

### Source Code (repository root)

```text
modules/
├── factory/             # Existing
├── hosts/               # Existing
├── nix/                 # Existing
├── private/             # NEW — git submodule → private GitHub repo
│   └── (follows same bracket-notation structure as other dirs)
├── programs/            # Existing
├── services/            # Existing
├── system/              # Existing
└── users/               # Existing

.gitmodules              # NEW or UPDATED — submodule entry for modules/private
```

**Structure Decision**: No new source code directories beyond
`modules/private/` itself (which is a git submodule). The main repo
only adds the `.gitmodules` entry and submodule reference. All actual
private module content lives in the external private repository.
