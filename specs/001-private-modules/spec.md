# Feature Specification: Private Modules Support

**Feature Branch**: `001-private-modules`
**Created**: 2026-03-30
**Status**: Draft
**Input**: User description: "add support for a set of private modules at modules/private, discovered through the current module import mechanism, and pointing to a git submodule hosted in a private github repo"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Add Private Modules to Configuration (Priority: P1)

As a configuration maintainer, I want to place private configuration
modules (containing secrets, proprietary settings, or personal config
not suitable for a public repo) under `modules/private/` and have them
automatically discovered and composed into my system builds, just like
any other module in `modules/`. The private directory is backed by a
separate private GitHub repository linked as a git submodule.

**Why this priority**: This is the core value proposition — without
automatic discovery working for the private directory, the feature
delivers nothing.

**Independent Test**: Can be verified by placing a valid module file
in `modules/private/`, running a system build, and confirming the
module's outputs are present in the resulting configuration.

**Acceptance Scenarios**:

1. **Given** a module file exists in `modules/private/` with the
   correct bracket-notation directory structure, **When** the system
   is rebuilt, **Then** the module is discovered and its outputs are
   composed into the build exactly as modules in other directories.
2. **Given** `modules/private/` contains modules that register
   homeManager, darwin, or nixos outputs, **When** a user file imports
   those module names, **Then** they resolve correctly.
3. **Given** the `modules/private/` directory is empty or absent
   (submodule not initialized), **When** the system is rebuilt,
   **Then** the build succeeds without errors — private modules are
   simply not included.

---

### User Story 2 - Clone and Initialize Private Modules (Priority: P2)

As a new machine or fresh clone user, I want clear guidance on how to
initialize the private submodule so that my private modules become
available. If I lack access to the private repo, the rest of my config
still builds and works.

**Why this priority**: Onboarding and portability are important but
secondary to the core discovery mechanism.

**Independent Test**: Clone the repo without initializing the
submodule, confirm the build works. Then initialize the submodule and
confirm private modules appear.

**Acceptance Scenarios**:

1. **Given** a fresh clone of the repository without `--recurse-submodules`,
   **When** the user runs a system build, **Then** the build completes
   successfully with no errors related to missing private modules.
2. **Given** a fresh clone, **When** the user initializes the submodule
   and rebuilds, **Then** private modules are discovered and active.

---

### User Story 3 - Maintain Private Modules Independently (Priority: P3)

As a configuration maintainer, I want to update, commit, and push
changes to private modules independently of the main repository, using
standard git submodule workflows.

**Why this priority**: Day-to-day maintenance of private content is
important for long-term usability but depends on the submodule being
set up first.

**Independent Test**: Make a change inside `modules/private/`, commit
and push in the submodule, then update the submodule reference in the
parent repo.

**Acceptance Scenarios**:

1. **Given** changes are made to files inside `modules/private/`,
   **When** the user commits within the submodule and updates the
   parent repo reference, **Then** the parent repo tracks the new
   submodule commit.
2. **Given** the private submodule is at a specific commit, **When**
   another machine clones and initializes the submodule, **Then** it
   checks out the same commit, producing an identical build.

---

### Edge Cases

- What happens when the submodule is initialized but the private repo
  is empty (no module files)? Build MUST succeed with no private
  module outputs.
- What happens when a private module declares an output name that
  collides with an existing public module? The build MUST surface a
  clear error rather than silently overriding.
- What happens when the user has no access to the private GitHub repo?
  Submodule initialization fails, but the main repo and build remain
  fully functional.
- What happens when `modules/private/` exists as a plain directory
  (not a submodule) with module files? They MUST still be discovered
  normally — the submodule mechanism is a deployment detail, not a
  discovery requirement.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The module discovery mechanism MUST scan `modules/private/`
  using the same auto-discovery rules applied to all other directories
  under `modules/`.
- **FR-002**: Private modules MUST support the same bracket-notation
  directory convention (`[D]`, `[N]`, `[n]`, etc.) as public modules.
- **FR-003**: Private module outputs MUST be composable via the same
  interfaces (`self.modules.homeManager.*`, `self.factory.*`, etc.)
  used by public modules.
- **FR-004**: The system build MUST succeed when `modules/private/`
  is absent, empty, or contains no valid module files (graceful
  degradation).
- **FR-005**: The private modules directory MUST be backed by a git
  submodule pointing to a private GitHub repository.
- **FR-006**: The `.gitmodules` entry for the private submodule MUST
  be present in the main repository so that collaborators with access
  can initialize it.
- **FR-007**: Flake regeneration (`nix run .#write-flake`) MUST
  correctly include or exclude private module outputs based on the
  presence of content in `modules/private/`.

### Key Entities

- **Private Module**: A flake-parts module file residing under
  `modules/private/` that self-registers outputs identically to
  public modules. Distinguished only by location, not by structure.
- **Git Submodule Reference**: The `.gitmodules` entry and tracked
  commit SHA linking `modules/private/` to the external private
  repository.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A module placed in `modules/private/` with correct
  bracket-notation structure is discovered and active in the system
  build within one rebuild cycle — zero additional manual wiring.
- **SC-002**: A fresh clone without submodule initialization builds
  successfully with 0 errors related to the private modules path.
- **SC-003**: 100% of existing public modules continue to build and
  function identically after the private modules directory is added
  (no regressions).
- **SC-004**: The private submodule can be initialized and updated
  using standard git commands with no custom scripts or tooling.

## Assumptions

- The existing import-tree discovery mechanism can scan additional
  subdirectories under `modules/` without configuration changes, or
  can be extended to do so.
- The private GitHub repository already exists (or will be created
  by the user outside the scope of this feature).
- The user has SSH or token-based access to the private GitHub
  repository configured on machines where private modules are needed.
- Only one private modules directory (`modules/private/`) is needed;
  multiple private submodule paths are out of scope.
- The private repository follows the same module file conventions
  (flake-parts modules with bracket-notation directories) as the
  main repository.
