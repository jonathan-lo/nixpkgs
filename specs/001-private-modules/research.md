# Research: Private Modules Support

**Branch**: `001-private-modules` | **Date**: 2026-03-30

## R1: Module Discovery Mechanism

**Decision**: No changes needed to the import-tree discovery mechanism.

**Rationale**: Import-tree (via `github:vic/import-tree`) recursively
scans all `.nix` files under `modules/` automatically. Adding a new
`modules/private/` subdirectory — with or without content — requires
zero configuration changes. Empty or absent directories are safely
ignored.

**Alternatives considered**:
- Custom import logic for private modules: Rejected — would violate
  Principle II (Modularity) by introducing a separate discovery path.
- Flake input for private repo: Rejected — adds complexity to
  `flake.nix` generation and breaks the "just drop files in modules/"
  pattern. A git submodule keeps the directory-based discovery intact.

## R2: Git Submodule vs Flake Input for Private Content

**Decision**: Use a git submodule at `modules/private/`.

**Rationale**: A git submodule places files directly into the
`modules/` tree, so import-tree discovers them identically to public
modules. No changes to `flake.nix`, no additional flake inputs, no
special handling in the build. The submodule is transparent to the
Nix evaluation layer.

**Alternatives considered**:
- Nix flake input pointing to the private repo: Would require custom
  import logic in flake-parts modules to merge external module trees.
  Violates Simplicity (Principle IV) and complicates `write-flake`.
- Nix fetchGit with SSH: Impure at evaluation time unless pinned with
  a hash; violates Reproducibility (Principle I).
- Symlink to external checkout: Not tracked by git; fragile across
  machines; violates Reproducibility.

## R3: Graceful Degradation When Submodule Is Absent

**Decision**: No special handling needed — import-tree naturally
handles this.

**Rationale**: When a git submodule is not initialized,
`modules/private/` either doesn't exist or exists as an empty
directory. Import-tree only processes `.nix` files, so both cases
produce zero modules — the build proceeds normally.

**Verification**: Confirmed by reading import-tree behavior: it walks
the directory tree looking for `.nix` files. No files = no imports =
no errors.

## R4: Flake Regeneration Impact

**Decision**: `nix run .#write-flake` requires no changes.

**Rationale**: The `flake-file` tool generates `flake.nix` based on
`flake-file.inputs` and `flake-file.outputs` declarations in modules.
The generated output line is:
```
inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ((import inputs.import-tree) ./modules)
```
This scans `./modules` at build time, so new subdirectories are
automatically included. No regeneration-specific changes needed.

## R5: Private Module Structure Conventions

**Decision**: Private modules follow identical conventions to public
modules (bracket notation, self-registration, kebab-case naming).

**Rationale**: Consistency with Principle II. The private repo is
structurally identical to a subtree of the main repo — just with
different content. Example structure:

```
modules/private/
├── programs/
│   └── some-private-tool [nd]/
│       └── some-private-tool.nix
└── services/
    └── some-private-service [D]/
        └── some-private-service.nix
```

## R6: Name Collision Between Public and Private Modules

**Decision**: Rely on Nix's native attribute-set merge behavior.
Duplicate keys in `flake.modules.homeManager.*` (or similar) will
produce an evaluation error at build time.

**Rationale**: Nix already surfaces clear errors for duplicate
attribute keys. No custom collision detection needed — the build
fails with a descriptive error pointing to the conflicting modules.
This is the same behavior that would occur if two public modules
declared the same output name.
