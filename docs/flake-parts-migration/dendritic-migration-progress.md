# Dendritic Migration Progress

**Date**: 2026-02-22
**Branch**: 2511
**Status**: In Progress

## Decisions Made

- **Composition**: Host composes - `budu.nix` explicitly lists which modules to include
- **Enable options**: Presence = enabled - remove enable options, module presence means it's active
- **Verification**: Functional equivalence accepted (same packages/configs, derivation hash may differ due to evaluation order)

## Completed Steps

### Phase 1: Infrastructure Setup ✅

1. **Added import-tree to flake.nix**
   - Added `inputs.flake-parts.flakeModules.modules` to enable `flake.modules` option
   - Added `(importTree ./modules)` to imports

2. **Removed inline budu definition from flake.nix**
   - Inline `nixosConfigurations.budu` removed (was lines 58-80)
   - Now defined in `modules/hosts/budu [N]/budu.nix`

3. **Staged modules/ directory for Git**
   - `git add modules/` - required for flake evaluation

### Phase 2: Module Migration (In Progress)

#### Migrated ✅

| Module | Source | Destination | Notes |
|--------|--------|-------------|-------|
| aws | `_legacy-modules/aws.nix` | `modules/programs/aws [nd]/aws.nix` | First migration, proof of concept |
| ai | `_legacy-modules/ai.nix` | `modules/programs/ai [nd]/ai.nix` | Includes claude/settings.json |
| bash | `_legacy-modules/bash.nix` | `modules/programs/bash [nd]/bash.nix` | Simple enable |
| bat | `_legacy-modules/bat.nix` | `modules/programs/bat [nd]/bat.nix` | Simple enable |
| btop | `_legacy-modules/btop.nix` | `modules/programs/btop [nd]/btop.nix` | Simple enable |
| direnv | `_legacy-modules/direnv.nix` | `modules/programs/direnv [nd]/direnv.nix` | With zsh integration |
| editor | `_legacy-modules/editor.nix` | `modules/programs/editor [nd]/editor.nix` | exercism, vscode |
| fzf | `_legacy-modules/fzf.nix` | `modules/programs/fzf [nd]/fzf.nix` | With tmux integration |

#### Pending

| Module | Type | Notes |
|--------|------|-------|
| ~~ai~~ | ~~packages + file~~ | ✅ Migrated |
| ~~bash~~ | ~~program~~ | ✅ Migrated |
| ~~bat~~ | ~~program~~ | ✅ Migrated |
| ~~btop~~ | ~~program~~ | ✅ Migrated |
| ~~direnv~~ | ~~program~~ | ✅ Migrated |
| ~~editor~~ | ~~packages~~ | ✅ Migrated |
| ~~fzf~~ | ~~program~~ | ✅ Migrated |
| go | packages + program | Has sessionPath config |
| gcp | packages | google-cloud-sdk with components |
| kubernetes | packages + aliases | Has zsh aliases via `modules.shell.zsh.aliases` |
| node | packages | TBD |
| ops | packages | TBD |
| platform | packages | TBD |
| ripgrep | program | TBD |
| git | options | Has `settings.git.defaultBranch` and `settings.git.email` options |
| zsh | options | Has `modules.shell.zsh` options - consumed by kubernetes.nix |
| bitwarden | enable→presence | Convert from `modules.bitwarden.enable` to presence-based |
| calibre | enable→presence | Convert from `modules.calibre.enable` to presence-based |
| firefox | enable→presence | Convert from `modules.firefox.enable` to presence-based |
| java | enable→presence | Directory module with enable option |
| theme | config | Catppuccin theming |
| tmux | config | Complex config with multiple files |
| docker | config | TBD |
| ghostty | directory | Has config files and shaders |
| lazyvim | directory | Has lua configs |

## Current File States

### flake.nix (modified)
```nix
outputs = inputs@{ ... }:
  let
    importTree = import inputs.import-tree;
  in
  flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [
      inputs.flake-parts.flakeModules.modules
      (importTree ./modules)
    ];
    systems = [ "x86_64-linux" "aarch64-darwin" ];
    flake = { ... };  # darwin and homeConfigurations remain inline
  };
```

### modules/hosts/budu [N]/budu.nix (modified)
```nix
home-manager.users.jlo = {
  imports = [
    ../../../hosts/linux/budu/home.nix
    catppuccin.homeModules.catppuccin
    config.flake.modules.homeManager.aws  # NEW - dendritic module
  ];
};
```

### home.nix (modified)
- Removed: `./_legacy-modules/aws.nix` from imports

### modules/programs/aws [nd]/aws.nix (new)
```nix
{ inputs, ... }:
{
  flake.modules.homeManager.aws = { pkgs, ... }: {
    home.packages = with pkgs; [
      unstable.awscli2
      amazon-ecr-credential-helper
      ssm-session-manager-plugin
    ];
  };
}
```

## Verification Commands

```bash
# Use the extraction verification script (handles baseline capture and comparison)
./scripts/verify-extraction.sh <flake-output> [label]           # capture baseline
./scripts/verify-extraction.sh <flake-output> [label] --verify  # compare after changes
./scripts/verify-extraction.sh --list                           # list active baselines
./scripts/verify-extraction.sh <flake-output> [label] --clean   # cleanup baseline

# Manual verification (if needed)
nix eval .#nixosConfigurations.budu.config.system.build.toplevel.drvPath
```

## Module Migration Pattern

For each legacy module:

1. **Capture baseline**
   ```bash
   ./scripts/verify-extraction.sh <flake-output> <module-name>
   # e.g. ./scripts/verify-extraction.sh nixosConfigurations.budu bash
   # e.g. ./scripts/verify-extraction.sh darwinConfigurations.Jonathans-MacBook-Pro bash
   ```

2. **Create dendritic module**
   ```nix
   # modules/programs/<feature> [nd]/<feature>.nix
   { inputs, ... }:
   {
     flake.modules.homeManager.<feature> = { pkgs, ... }: {
       # Same content as legacy module
     };
   }
   ```

3. **Update BOTH host modules** - add to imports in each:
   - `modules/hosts/budu [N]/budu.nix`
   - `modules/hosts/macbook [D]/macbook.nix`
   ```nix
   config.flake.modules.homeManager.<feature>
   ```

4. **Update home.nix** - remove legacy import

5. **Stage for git**: `git add "modules/programs/<feature> [nd]/<feature>.nix"`

6. **Verify equivalence**
   ```bash
   ./scripts/verify-extraction.sh <flake-output> <module-name> --verify
   ```

## Special Cases

### Modules with file references (ai.nix)
- Need to adjust paths or copy files to new location
- Example: `./claude/settings.json` → `../../../_legacy-modules/claude/settings.json`

### Modules with options consumed elsewhere (zsh.nix)
- Keep options interface: `modules.shell.zsh.aliases`
- kubernetes.nix depends on this

### Modules with enable options (bitwarden, firefox, etc.)
- Convert to presence-based (no enable option)
- Remove `modules.X.enable = true` from hosts/linux/budu/home.nix

## Next Steps

### Phase 1.5: Extract MacBook Host to Module

Extract `darwinConfigurations."Jonathans-MacBook-Pro"` from inline flake.nix to its own module.

#### Before (capture baseline)
```bash
./scripts/verify-extraction.sh darwinConfigurations.Jonathans-MacBook-Pro macbook
```

#### Steps

1. **Create host module file**
   ```bash
   mkdir -p "modules/hosts/macbook [D]"
   ```

2. **Create `modules/hosts/macbook [D]/macbook.nix`**
   ```nix
   { inputs, config, ... }:
   let
     inherit (inputs) darwin home-manager catppuccin;

     overlay = final: prev: {
       unstable = import inputs.nixpkgs-unstable {
         system = prev.stdenv.hostPlatform.system;
         config.allowUnfree = true;
       };
     };

     overlays = [ overlay ];

     nixPkgsConfig = {
       inherit overlays;
       config.allowUnfree = true;
     };
   in
   {
     flake.darwinConfigurations."Jonathans-MacBook-Pro" = darwin.lib.darwinSystem {
       system = "aarch64-darwin";

       specialArgs = { inherit inputs; };

       modules = [
         home-manager.darwinModules.home-manager
         {
           nixpkgs = nixPkgsConfig;
           home-manager.useGlobalPkgs = true;
           home-manager.users.jlo = {
             imports = [
               ../../../hosts/darwin/nc/home.nix
               catppuccin.homeModules.catppuccin
             ];
           };
         }
         ../../../hosts
         ../../../hosts/darwin/homebrew.nix
         ../../../hosts/darwin/services.nix
         ../../../hosts/darwin/settings.nix
       ];
     };
   }
   ```

3. **Stage for git**
   ```bash
   git add "modules/hosts/macbook [D]/macbook.nix"
   ```

4. **Remove inline definition from flake.nix**
   - Remove `darwinConfigurations."Jonathans-MacBook-Pro"` block (lines 67-89)
   - Remove `overlay`, `overlays`, `nixPkgsConfig` if no longer used by other configs

5. **Verify logical equivalence**
   ```bash
   ./scripts/verify-extraction.sh darwinConfigurations.Jonathans-MacBook-Pro macbook --verify
   ```

6. **Test activation**
   ```bash
   sudo darwin-rebuild switch --flake .
   ```

### Phase 2: Module Migration

1. Continue migrating simple modules (ai, bash, bat, btop, direnv, editor, fzf, go, gcp, kubernetes, node, ops, platform, ripgrep)
2. Handle modules with options (git, zsh) - preserve option interfaces
3. Convert enable-based modules (bitwarden, calibre, firefox, java) to presence-based
4. Migrate directory modules (ghostty, lazyvim, tmux)
5. Clean up home.nix and hosts/linux/budu/home.nix
6. Delete _legacy-modules/ after full migration

## Git Status

```
Modified:
  flake.nix
  home.nix
  modules/hosts/budu [N]/budu.nix

New (staged):
  modules/programs/aws [nd]/aws.nix
  (other modules/ files already staged)

Untracked:
  docs/flake-parts-migration/dendritic-migration-progress.md
```
