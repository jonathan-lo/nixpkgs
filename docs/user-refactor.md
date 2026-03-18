# Migrate user `jlo` to use the user factory

## Context

The user factory at `modules/factory/user [ND]/user.nix` was recently added (commit 2585c44) but is not yet used. Currently, user `jlo` is defined inline in each host config (budu, macbook). This migration wires up the factory following the pattern from the reference repo (Doc-Steve/den), producing logically equivalent derivations.

## Changes

### 1. Rewrite `modules/users/jlo [nd]/jlo.nix`

Replace the current unused `homeManager.userJlo` module with the factory pattern:

```nix
{ self, lib, ... }:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "jlo" true)
    {
      nixos.jlo = {
        users.users.jlo.extraGroups = [ "docker" "networkmanager" ];
      };

      darwin.jlo = { };

      homeManager.jlo = { ... }: {
        imports = with self.modules.homeManager; [
          ai aws bash bat btop cli direnv docker editor
          firefox fzf gcp go java kubernetes node ops
          git platform ripgrep theming tmux zoxide zsh
          ghostty lazyvim
        ];
        home.stateVersion = "22.05";
      };
    }
  ];
}
```

This creates `modules.nixos.jlo`, `modules.darwin.jlo`, and `modules.homeManager.jlo`. The factory provides the base user account, zsh, and home-manager wiring. The merge adds:
- **nixos.jlo**: extra groups `docker` and `networkmanager` (factory already adds `wheel` via `isAdmin`)
- **homeManager.jlo**: shared home-manager imports common to both platforms, plus `stateVersion`

### 2. Update `modules/hosts/linux [N]/budu/configuration.nix`

- Add `jlo` to the nixos `imports` list
- Remove the inline `users.users.jlo` block (lines 88-96)
- Replace the `home-manager.users.jlo` block (lines 113-150) with only budu-specific additions:

```nix
home-manager.users.jlo = {
  imports = with inputs.self.modules.homeManager; [
    bitwarden browsers calibre
  ];
};
```

### 3. Update `modules/hosts/darwin [D]/nc/configuration.nix`

- Add `jlo` to the darwin `imports` list
- Remove the inline `users.users.jlo` and `system.primaryUser` lines
- Replace the `home-manager.users.jlo` block with only darwin-specific additions:

```nix
home-manager.users.jlo = {
  imports = with inputs.self.modules.homeManager; [
    nix-darwin
  ];
};
```

### 4. Rename directory tag

Rename `modules/users/jlo [nd]` to `modules/users/jlo [ND]` since the user module now produces both nixos and darwin modules (uppercase = provides modules for that platform).

## Files modified

| File | Action |
|------|--------|
| `modules/users/jlo [nd]/jlo.nix` | Rewrite to use factory pattern |
| `modules/hosts/linux [N]/budu/configuration.nix` | Import user module, remove inline user config |
| `modules/hosts/darwin [D]/nc/configuration.nix` | Import user module, remove inline user/primaryUser config |
| `modules/users/jlo [nd]` | Rename to `[ND]` |

## Not changed

- **WSL hosts** (`modules/hosts/wsl []/wsl.nix`): These are standalone `homeManagerConfiguration` calls, not system configs. They don't use the nixos/darwin module system and won't benefit from the factory. Leave as-is.
- **User factory** (`modules/factory/user [ND]/user.nix`): No changes needed.

## Equivalence notes

- Factory sets `shell = pkgs.zsh` — current budu config doesn't set shell explicitly, so this is an addition (harmless, aligns with darwin)
- Factory sets `programs.zsh.enable = true` — already implied by usage, now explicit
- Factory sets `home = "/home/jlo"` — matches NixOS default
- `description = "jonathan"` on budu's user is dropped (not in factory)

## Verification

### Step 0: Capture pre-migration derivation state (before any changes)

```bash
# Capture budu NixOS derivation path
nix eval .#nixosConfigurations.budu.config.system.build.toplevel.drvPath 2>/dev/null > /tmp/budu-pre.txt

# Capture darwin derivation path (will fail on linux, but capture the eval)
nix eval .#darwinConfigurations.Jonathans-MacBook-Pro.config.system.build.toplevel.drvPath 2>/dev/null > /tmp/darwin-pre.txt || true
```

### Step 1: After migration, capture post-migration state

```bash
nix eval .#nixosConfigurations.budu.config.system.build.toplevel.drvPath 2>/dev/null > /tmp/budu-post.txt
nix eval .#darwinConfigurations.Jonathans-MacBook-Pro.config.system.build.toplevel.drvPath 2>/dev/null > /tmp/darwin-post.txt || true
```

### Step 2: Compare

```bash
diff /tmp/budu-pre.txt /tmp/budu-post.txt
diff /tmp/darwin-pre.txt /tmp/darwin-post.txt
```

Expected: derivation paths will differ slightly due to the added `shell = pkgs.zsh`, `programs.zsh.enable = true`, and `home = "/home/jlo"` from the factory. These are intentional additions that align the NixOS config with the darwin config. The diff confirms no unintended changes.

### Step 3: Verify builds

```bash
nix flake check
nix build .#nixosConfigurations.budu.config.system.build.toplevel --dry-run
```
