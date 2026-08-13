# Module organisation: category bundles for home-manager

## Context

The `imports = with self.modules.homeManager; [ … ]` list in
`modules/users/jlo [ND]/jlo.nix` is ~30 names maintained by hand, which felt
like it contradicted the "dendritic" pattern this repo follows.

**Resolved conceptually:** it does *not* contradict the pattern. import-tree's
auto-discovery is about **file collection** (files → modules), never about
**activation** (modules → configs). Choosing which registered modules a config
turns on via an `imports` list is the pattern's intended consumer step — the
canonical dendritic setups do exactly this. The one cosmetic deviation is that
this repo uses `self.modules` / `inputs.self.modules` where textbook dendritic
uses `config.flake.modules.<class>`.

**Still worth doing:** the base list is long and re-derived per consumer. This
design shrinks it to a handful of category bundles that auto-fold, so adding a
program module no longer requires editing the base list.

## Current setup (accurate model)

- **Base HM profile:** `modules/users/jlo [ND]/jlo.nix` (~30 modules), shared
  by both the darwin host (`nc`) and the NixOS host (`budu`) via the factory
  (`modules/factory/user [ND]/user.nix` → `home-manager.users.jlo`).
- **Per-host HM overlays** (real selectivity, keep as-is):
  - `modules/hosts/linux [N]/budu/users/jlo.nix` adds `bitwarden`, `calibre`.
  - `modules/hosts/darwin [D]/nc/users/jlo.nix` adds none (sessionPath only).
- **WSL** (`modules/hosts/wsl []/wsl.nix`) bypasses the HM modules entirely —
  hand-rolled minimal home. Out of scope.
- All HM leaves currently register **flat**: `flake.modules.homeManager.<name>`.

## Design

Scope: **home-manager program modules only.** Leave the nixos/darwin system
host lists (`budu`, `nc`) and system-cli plumbing untouched — those encode real
per-host divergence and read fine as explicit lists.

1. **Namespace leaves by their directory category** — the only per-file edit:
   ```
   flake.modules.homeManager.by.<category>.<name>
   ```
   e.g. `by.cli.bat`, `by.lang.go`, `by.terminal.tmux`, `by.git.git`,
   `by.editor.lazyvim`. Mechanical: prefix the existing name with `by.<dir>.`.

2. **Auto-derive bundles** from `.by` (no hardcoded category list) — one new
   generator module:
   ```nix
   { config, lib, ... }:
   {
     flake.modules.homeManager.bundles =
       lib.mapAttrs (_: mods: { imports = lib.attrValues mods; })
         config.flake.modules.homeManager.by;
   }
   ```
   Recursion-safe: `bundles` reads `.by`; profiles read `bundles`.

3. **Base profile** `jlo.nix` collapses to category names, not module names:
   ```nix
   imports = with self.modules.homeManager.bundles; [
     cli lang cloud terminal desktop git editor
   ];
   ```
   (Keeping the explicit category list preserves a legible manifest of
   *categories*; `lib.attrValues hm.bundles` would fold all of them implicitly.)

4. **Opt-in apps move out of `programs/cli/`** into `programs/apps/` so base
   bundles never fold them:
   - Move `bitwarden.nix`, `calibre.nix` → `programs/apps/` → `by.apps.*`.
   - `budu` overlay becomes `imports = with hm.by.apps; [ bitwarden calibre ]`.
   This makes directory structure == base-vs-optional truth again.

## Files touched (when implemented)

- **Renamespace (mechanical, ~30):** all leaves under `modules/programs/**`
  that register `flake.modules.homeManager.<name>` → `…homeManager.by.<dir>.<name>`.
  Representative: `programs/cli/bat.nix`, `programs/lang/go.nix`,
  `programs/terminal/tmux [nd]/…`, `programs/git [nd]/git.nix`,
  `programs/editor [nd]/…`, `programs/lazyvim [nd]/…`.
- **Move:** `programs/cli/bitwarden.nix`, `programs/cli/calibre.nix` →
  `programs/apps/`.
- **New:** one bundle-generator module (e.g. `modules/programs/bundles.nix`).
- **Edit consumers:** `modules/users/jlo [ND]/jlo.nix` (base list → bundles);
  `modules/hosts/linux [N]/budu/users/jlo.nix` (apps overlay path).

## Explicitly NOT touched

- nixos/darwin system host import lists (`budu`, `nc`) and
  `modules/system/02-system-cli/system-cli.nix`.
- Cross-class refs to specific HM names that live outside `programs/`:
  `karabiner`, `homebrew`, `nix-darwin`, `platform-cli`, `system-minimal` —
  their flat names stay flat.
- WSL standalone home.

## Verification (when implemented)

1. `nix run .#write-flake` — regenerate flake.nix from modules.
2. `just build` — dry-run darwin build; must evaluate with no missing-attr or
   infinite-recursion errors.
3. `/nix-drv-check` on staged changes — confirm the darwin/nixos derivations are
   **identical** before vs. after (this is a pure refactor; the set of active
   modules per host must not change).
4. Spot-check: `budu` still gets `bitwarden`/`calibre`; `nc` does not.
