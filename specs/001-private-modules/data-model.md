# Data Model: Private Modules Support

**Branch**: `001-private-modules` | **Date**: 2026-03-30

## Entities

### Private Module

A flake-parts module file under `modules/private/`. Structurally
identical to a public module — distinguished only by file path.

**Attributes**:
- File path: `modules/private/<category>/<name> [BRACKET]/<name>.nix`
- Output key: `flake.modules.<layer>.<name>` (e.g.,
  `flake.modules.homeManager.my-private-tool`)
- Platform scope: Determined by bracket notation on parent directory

**Relationships**:
- Composed into system configurations via `self.modules.*` references
  in user files (e.g., `jlo.nix`)
- May depend on public modules (same as any cross-module dependency)

### Git Submodule Reference

The link between `modules/private/` in the main repo and the external
private GitHub repository.

**Attributes**:
- Path: `modules/private`
- URL: SSH URL to private GitHub repository
- Tracked commit: SHA recorded in main repo's git index

**State transitions**:
- **Uninitialized**: Directory absent or empty; build works, no
  private modules active
- **Initialized**: Directory populated with private repo content;
  private modules discovered and active
- **Updated**: Submodule advanced to a new commit; private modules
  reflect updated content after rebuild
