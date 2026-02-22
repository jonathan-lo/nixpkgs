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

#### Pending

| Module | Type | Notes |
|--------|------|-------|
| ai | packages + file | Has `home.file` for claude settings.json - needs path adjustment |
| bash | program | Simple `programs.bash.enable = true` |
| bat | program | Simple `programs.bat.enable = true` |
| btop | program | Simple `programs.btop.enable = true` |
| direnv | program | Has zsh integration |
| editor | packages | exercism, vscode |
| fzf | program | Has tmux integration |
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
# Verify flake evaluates successfully
nix eval .#nixosConfigurations.budu.config.system.build.toplevel.drvPath

# Compare package counts (should be identical)
nix derivation show <baseline-hm-path.drv> | jq '.derivations[].inputs.drvs | keys | length'
nix derivation show <current-hm-path.drv> | jq '.derivations[].inputs.drvs | keys | length'
```

## Module Migration Pattern

For each legacy module:

1. **Create dendritic module**
   ```nix
   # modules/programs/<feature> [nd]/<feature>.nix
   { inputs, ... }:
   {
     flake.modules.homeManager.<feature> = { pkgs, ... }: {
       # Same content as legacy module
     };
   }
   ```

2. **Update budu.nix** - add to imports:
   ```nix
   config.flake.modules.homeManager.<feature>
   ```

3. **Update home.nix** - remove legacy import

4. **Stage for git**: `git add "modules/programs/<feature> [nd]/<feature>.nix"`

5. **Verify**: `nix eval .#nixosConfigurations.budu.config.system.build.toplevel.drvPath`

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
