# Tasks: Private Modules Support

**Input**: Design documents from `/specs/001-private-modules/`
**Prerequisites**: plan.md (required), spec.md (required), research.md, data-model.md, quickstart.md

**Tests**: Not explicitly requested in the spec. Test tasks omitted.

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup

**Purpose**: Create the private GitHub repository and link it as a submodule

- [X] T001 Create a private GitHub repository for private modules (e.g., `github.com/<owner>/nixpkgs-private`)
- [X] T002 Add git submodule pointing to the private repo at modules/private via `git submodule add git@github.com:<owner>/<private-repo>.git modules/private`
- [X] T003 Verify .gitmodules contains the correct entry for modules/private

**Checkpoint**: Submodule reference exists in the repository; `modules/private/` is a valid git submodule directory.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Verify import-tree discovers `modules/private/` without configuration changes

**IMPORTANT**: No user story work can begin until this phase confirms discovery works.

- [X] T004 Run `just build` with empty `modules/private/` to confirm graceful degradation — build MUST succeed with no errors
- [X] T005 Run `nix run .#write-flake` and verify the regenerated flake.nix is unchanged (import-tree scans `./modules` which already includes `modules/private/`)

**Checkpoint**: Foundation ready — empty submodule does not break the build or flake regeneration.

---

## Phase 3: User Story 1 - Add Private Modules to Configuration (Priority: P1) MVP

**Goal**: Private modules in `modules/private/` are automatically discovered and composed into builds.

**Independent Test**: Place a module in `modules/private/`, rebuild, confirm its outputs are active.

### Implementation for User Story 1

- [X] T006 [US1] Create a sample private module directory structure: `modules/private/programs/sample-private [nd]/`
- [X] T007 [US1] Create a sample private flake-parts module at `modules/private/programs/sample-private [nd]/sample-private.nix` that registers `flake.modules.homeManager.sample-private` with a minimal config (e.g., sets a shell alias)
- [X] T008 [US1] Run `nix run .#write-flake` to regenerate flake.nix
- [X] T009 [US1] Run `just build` to verify the sample private module is discovered and the build succeeds
- [X] T010 [US1] Import the `sample-private` module in a user file (e.g., `modules/users/jlo [ND]/jlo.nix`) by adding it to the `imports = with self.modules.homeManager; [ ... sample-private ... ];` list
- [X] T011 [US1] Run `just build` again to verify the imported private module outputs are present in the configuration
- [X] T012 [US1] Remove the sample import from the user file and delete the sample module from `modules/private/` (cleanup — real private modules will be authored in the private repo)
- [X] T013 [US1] Run `just build` one final time to confirm the build still succeeds with `modules/private/` empty

**Checkpoint**: User Story 1 complete — private modules are discovered, composable, and the build gracefully handles an empty private directory.

---

## Phase 4: User Story 2 - Clone and Initialize Private Modules (Priority: P2)

**Goal**: Fresh clones work with or without submodule initialization.

**Independent Test**: Clone without `--recurse-submodules`, build succeeds. Initialize submodule, rebuild, private modules appear.

### Implementation for User Story 2

- [X] T014 [US2] Verify that a fresh clone without `--recurse-submodules` results in `modules/private/` being empty (submodule not initialized)
- [X] T015 [US2] Run `just build` on the fresh clone to confirm the build succeeds with 0 errors related to `modules/private/`
- [X] T016 [US2] Run `git submodule update --init` and confirm `modules/private/` is populated with the private repo content
- [X] T017 [US2] Run `just build` after submodule initialization to confirm private modules are now discovered

**Checkpoint**: User Story 2 complete — onboarding works in both scenarios (with and without private access).

---

## Phase 5: User Story 3 - Maintain Private Modules Independently (Priority: P3)

**Goal**: Private modules can be updated, committed, and pushed independently via standard git submodule workflows.

**Independent Test**: Modify a file in `modules/private/`, commit in the submodule, update the parent repo reference.

### Implementation for User Story 3

- [X] T018 [US3] Create or modify a module file inside `modules/private/` in the submodule working directory
- [X] T019 [US3] Commit and push the change within the `modules/private/` submodule
- [X] T020 [US3] In the parent repo, run `git add modules/private` to update the tracked submodule commit
- [X] T021 [US3] Commit the submodule reference update in the parent repo
- [X] T022 [US3] Run `just build` to verify the updated private module content is reflected in the build

**Checkpoint**: User Story 3 complete — independent maintenance workflow validated.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Cleanup and ensure long-term maintainability

- [X] T023 [P] Add `modules/private/` to .gitignore if desired for forks without private access (optional — evaluated: not needed, submodule gracefully degrades)
- [X] T024 Run `just lint` to ensure all committed .nix files pass formatting
- [X] T025 Run `just build` as a final regression check across the full module tree

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 (submodule must exist)
- **User Story 1 (Phase 3)**: Depends on Phase 2 (discovery confirmed)
- **User Story 2 (Phase 4)**: Depends on Phase 1 (submodule registered in .gitmodules)
- **User Story 3 (Phase 5)**: Depends on Phase 3 (at least one module exists to modify)
- **Polish (Phase 6)**: Depends on all stories complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational — no dependencies on other stories
- **User Story 2 (P2)**: Can start after Setup — independent of US1 (tests clone behavior, not module content)
- **User Story 3 (P3)**: Depends on US1 (needs module content to modify)

### Parallel Opportunities

- T014–T017 (US2) can run in parallel with T006–T013 (US1) since they test different scenarios
- T023 and T024 in Polish phase can run in parallel

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (create repo, add submodule)
2. Complete Phase 2: Foundational (verify empty build works)
3. Complete Phase 3: User Story 1 (test module discovery end-to-end)
4. **STOP and VALIDATE**: Confirm private modules work
5. Commit and use

### Incremental Delivery

1. Setup + Foundational → Submodule wired up
2. User Story 1 → Module discovery validated (MVP!)
3. User Story 2 → Fresh clone experience validated
4. User Story 3 → Maintenance workflow validated
5. Polish → Lint, final checks

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- This feature is primarily a wiring/integration task — most "implementation" is verifying existing mechanisms work with the new directory
- No custom code is needed in the main repo; import-tree handles discovery automatically
- The sample module in Phase 3 is for validation only; real private modules are authored in the private repo
