<!--
Sync Impact Report
===================
- Version change: 0.0.0 → 1.0.0
- Modified principles: N/A (initial ratification)
- Added sections: Core Principles (5), Module Conventions, Development Workflow, Governance
- Removed sections: N/A
- Templates requiring updates:
  - .specify/templates/plan-template.md — ✅ no updates needed (Constitution Check is generic)
  - .specify/templates/spec-template.md — ✅ no updates needed (technology-agnostic)
  - .specify/templates/tasks-template.md — ✅ no updates needed (structure-agnostic)
  - .specify/templates/commands/*.md — ✅ no command templates exist
- Follow-up TODOs: none
-->

# Nixpkgs Configuration Constitution

## Core Principles

### I. Reproducibility First

All system configurations MUST produce deterministic, reproducible
results. Flake inputs MUST be pinned via `flake.lock`. Impure
operations (e.g., `builtins.fetchurl` without hash, `builtins.currentTime`)
are forbidden. Every rebuild from the same commit MUST yield an
identical derivation. Use `/nix-drv-check` to verify refactors
preserve derivation identity.

### II. Modularity & Composability

Every configuration module MUST be self-contained and independently
composable. Modules self-register their outputs via flake-parts — no
central imports list. A module MUST declare its platform scope via
directory bracket notation (e.g., `[ND]`, `[n]`). Cross-module
dependencies MUST flow through well-defined interfaces
(`self.modules.homeManager.*`, `self.factory.*`, `self.lib.*`),
never through implicit file-path coupling.

### III. Cross-Platform Parity

macOS (nix-darwin), NixOS, and WSL (home-manager) configurations
MUST share the maximum feasible amount of code. Platform-specific
divergence MUST be isolated in appropriately bracketed directories
and justified by genuine platform constraints. Shared logic belongs
in `[n]`/`[nd]` homeManager modules; platform-only logic belongs in
`[D]`, `[N]`, or host-specific directories.

### IV. Simplicity & YAGNI

Prefer explicit configuration over abstraction. Do not introduce
helper functions, overlays, or factory patterns unless they eliminate
meaningful duplication across at least two concrete use sites.
Speculative features and unused options MUST NOT be added. When in
doubt, inline. Three similar lines are better than a premature
abstraction.

### V. Build Safety

Every change MUST be verifiable before applying to the running
system. Use `just build` (dry-run) to validate before `just apply`.
Use `just lint` to enforce formatting. Staged changes that alter
module structure MUST pass `/nix-drv-check` to confirm derivation
equivalence. `flake.nix` MUST NOT be edited directly — always
regenerate via `nix run .#write-flake`.

## Module Conventions

- **Bracket notation**: Directory names encode platform scope per the
  bracket table in CLAUDE.md. Misnaming a bracket silently excludes
  or misroutes a module — treat bracket accuracy as a correctness
  requirement.
- **Self-registration**: Each `.nix` file under `modules/` is a
  flake-parts module discovered by import-tree. It MUST set its
  output key (e.g., `flake.modules.homeManager.git = { ... }`).
- **Factory pattern**: `self.factory.user` generates cross-platform
  user configs. New users MUST use the factory rather than
  duplicating platform-specific user setup.
- **Overlays**: The `nixpkgs.nix` overlay exposes
  `pkgs.unstable.*`. Additional overlays MUST be justified by a
  concrete need and documented in their module file.
- **Naming**: Module files MUST use lowercase kebab-case. Directory
  names follow `<descriptive-name> [BRACKET]` convention.

## Development Workflow

- **Rebuild**: `just apply` rebuilds the active system configuration.
- **Dry-run**: `just build` validates the build without applying.
- **Lint**: `just lint` formats all `.nix` files with nixfmt. All
  committed code MUST pass lint.
- **Flake regeneration**: `nix run .#write-flake` regenerates
  `flake.nix` from modules. Run after adding or removing module
  files.
- **Dependency updates**: `just update` updates `flake.lock`. Review
  the diff before committing.
- **Refactor safety**: `/nix-drv-check` compares derivations before
  and after staged changes. MUST pass for pure refactors.
- **Commits**: Use conventional-style messages. One logical change
  per commit. Do not commit generated files (`flake.nix`) with
  manual edits.

## Governance

This constitution is the authoritative source of project principles.
It supersedes ad-hoc practices and informal conventions. Amendments
follow this process:

1. Propose the change with rationale.
2. Update this file with the amendment.
3. Increment the version per semantic versioning:
   - **MAJOR**: Principle removed or fundamentally redefined.
   - **MINOR**: New principle or section added, or material expansion.
   - **PATCH**: Clarifications, wording fixes, non-semantic edits.
4. Update `LAST_AMENDED_DATE` to the amendment date.
5. Run the consistency propagation checklist against dependent
   templates (plan, spec, tasks) and update if needed.

All configuration changes (PRs, reviews) MUST verify compliance
with these principles. Complexity beyond what the principles permit
MUST be justified in the relevant spec or plan document.

Refer to `CLAUDE.md` for runtime development guidance and command
reference.

**Version**: 1.0.0 | **Ratified**: 2026-03-30 | **Last Amended**: 2026-03-30
