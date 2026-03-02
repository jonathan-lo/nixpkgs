# Phase 6: Testing and Validation

## Objective

Verify the migration is complete and all configurations work correctly.

## Validation Checklist

### 6.1 Flake Structure Validation

```bash
# Show all flake outputs
nix flake show

# Expected output should include:
# ├── darwinConfigurations
# │   └── Jonathans-MacBook-Pro
# ├── homeConfigurations
# │   ├── DESKTOP-7RRDPPB
# │   └── LAPTOP-GIVRN79I
# ├── lib
# │   ├── mkDarwin
# │   ├── mkHome
# │   └── mkNixos
# └── nixosConfigurations
#     └── budu
```

```bash
# Check for evaluation errors
nix flake check
```

### 6.2 Build Validation

Test each configuration builds without errors:

```bash
# NixOS - dry build
nixos-rebuild dry-build --flake .#budu

# Darwin - dry build
darwin-rebuild build --flake .#Jonathans-MacBook-Pro --dry-run

# Home-manager - dry build
home-manager build --flake .#DESKTOP-7RRDPPB --dry-run
home-manager build --flake .#LAPTOP-GIVRN79I --dry-run
```

### 6.3 Configuration Diff

Compare old vs new configurations to catch regressions:

```bash
# For NixOS, compare system paths
# First, build old config (before migration, from git)
git stash
nixos-rebuild build --flake .#budu -o /tmp/old-budu

# Then build new config
git stash pop
nixos-rebuild build --flake .#budu -o /tmp/new-budu

# Compare
nix-diff /tmp/old-budu /tmp/new-budu
```

### 6.4 Module Availability

Verify all expected modules exist:

```bash
# Check lib functions exist
nix eval .#lib.mkNixos --apply 'x: "exists"'
nix eval .#lib.mkDarwin --apply 'x: "exists"'
nix eval .#lib.mkHome --apply 'x: "exists"'

# Check modules are defined (adjust paths as needed)
nix eval .#modules.nixos.nixpkgsConfig --apply 'x: "exists"' 2>/dev/null || echo "Module not found"
nix eval .#modules.homeManager.theming --apply 'x: "exists"' 2>/dev/null || echo "Module not found"
```

### 6.5 Feature Composition Test

Create a test file to verify features can be composed:

```nix
# modules/_test-composition.nix (excluded from import due to _ prefix)
# Rename to test-composition.nix to run test
{ inputs, config, ... }:
let
  testConfig = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.nixos.nixpkgsConfig
      config.flake.modules.nixos.homeManagerIntegration
      {
        home-manager.users.testuser = {
          imports = [
            config.flake.modules.homeManager.theming
          ];
          home.homeDirectory = "/home/testuser";
          home.stateVersion = "24.05";
        };
        networking.hostName = "test-host";
        system.stateVersion = "24.05";
        fileSystems."/" = { device = "/dev/null"; fsType = "ext4"; };
        boot.loader.grub.device = "/dev/null";
      }
    ];
  };
in
{
  flake.checks.x86_64-linux.composition-test = testConfig.config.system.build.toplevel;
}
```

```bash
# Run the check
nix build .#checks.x86_64-linux.composition-test
```

## Deployment Validation

### 6.6 Staged Rollout

Deploy one host at a time, keeping rollback available:

```bash
# NixOS - switch with rollback available
sudo nixos-rebuild switch --flake .#budu

# If something breaks:
sudo nixos-rebuild switch --rollback

# Darwin
darwin-rebuild switch --flake .#Jonathans-MacBook-Pro

# Home-manager
home-manager switch --flake .#DESKTOP-7RRDPPB
```

### 6.7 Post-Deploy Verification

After switching, verify:

```bash
# Check system version
nixos-version  # or sw_vers on macOS

# Check home-manager version
home-manager --version

# Check a known program is available
which zsh
which git

# Check catppuccin theme is applied (varies by application)
# e.g., check GTK theme, terminal colors, etc.
```

## Cleanup

### 6.8 Remove Old Files

After validation, remove obsolete files:

```bash
# List files to remove
ls -la hosts/

# Archive or remove old structure
mv hosts/ _archived_hosts/  # Keep backup initially
# Or: rm -rf hosts/

# Remove any _test files
rm modules/_test*.nix
```

### 6.9 Update .gitignore

Add patterns for dendritic workflow:

```bash
# Add to .gitignore
echo "# Dendritic workflow" >> .gitignore
echo "modules/_*" >> .gitignore
echo "result" >> .gitignore
echo "result-*" >> .gitignore
```

### 6.10 Final Commit

```bash
git add -A
git commit -m "Migrate to flake-parts dendritic design

- Add flake-parts and import-tree inputs
- Create modules/ structure with features
- Extract common patterns (nixpkgs, theming, home-manager)
- Convert all hosts to dendritic pattern
- Add helper functions (mkNixos, mkDarwin, mkHome)
- Remove old hosts/ structure"
```

## Troubleshooting Common Issues

### Issue: "attribute 'foo' missing"

**Cause**: A module reference is wrong or module wasn't imported.

**Fix**: Check the module path exists and is properly defined:
```bash
# List all imported files
find modules -name "*.nix" ! -name "_*"

# Check module defines the expected attribute
grep -r "flake.modules.nixos.foo" modules/
```

### Issue: "infinite recursion encountered"

**Cause**: Circular imports or self-referential definitions.

**Fix**:
- Don't import a module from within itself
- Use `lib.mkDefault` or `lib.mkOverride` to break cycles
- Check for modules that import each other

### Issue: "option 'X' has conflicting definitions"

**Cause**: Same option set in multiple places without merge strategy.

**Fix**:
```nix
# Use lib.mkDefault for "soft" defaults
programs.zsh.enable = lib.mkDefault true;

# Use lib.mkForce to override
programs.zsh.enable = lib.mkForce false;

# Use lib.mkMerge for lists/attrs
environment.systemPackages = lib.mkMerge [
  [ pkgs.vim ]
  (lib.mkIf config.services.xserver.enable [ pkgs.firefox ])
];
```

### Issue: "cannot find flake 'path:./modules'"

**Cause**: import-tree path is wrong.

**Fix**: Verify the path in flake.nix:
```nix
imports = [
  (import inputs.import-tree ./modules)  # Should be relative to flake.nix
];
```

### Issue: Host-specific settings override features

**Cause**: Priority/merge order issue.

**Fix**: Features should use `mkDefault`, hosts can override:
```nix
# In feature
flake.modules.homeManager.shell = {
  programs.zsh.enable = lib.mkDefault true;
  programs.zsh.defaultKeymap = lib.mkDefault "emacs";
};

# In host (overrides feature)
programs.zsh.defaultKeymap = "viins";
```

## Final Checklist

- [ ] `nix flake show` displays expected structure
- [ ] `nix flake check` passes
- [ ] All hosts build: `nixos-rebuild dry-build`, `darwin-rebuild --dry-run`, `home-manager build`
- [ ] Deployed and verified on at least one host
- [ ] Old `hosts/` directory archived/removed
- [ ] Git history clean with descriptive commit
- [ ] README updated (optional)

## Post-Migration Workflow

### Adding a New Feature

1. Create `modules/programs/newfeature [nd]/newfeature.nix`
2. Define `flake.modules.homeManager.newfeature = { ... };`
3. Import in hosts that need it: `config.flake.modules.homeManager.newfeature`

### Adding a New Host

1. Create `modules/hosts/newhostname [N]/`
2. Add `flake-parts.nix` using `mkNixos` helper
3. Add `configuration.nix`, `hardware.nix`, `home.nix`
4. Build: `nixos-rebuild dry-build --flake .#newhostname`

### Updating a Feature

1. Edit the feature file in `modules/`
2. Rebuild affected hosts
3. Changes apply to all hosts using that feature

## Congratulations!

Your flake is now using the dendritic design pattern. Benefits you'll notice:

- **Adding features**: 1 file + 1 line per host
- **Finding settings**: Look in the feature module, not scattered across hosts
- **Consistent environments**: Same feature = same config everywhere
- **Cleaner diffs**: Feature changes isolated to feature files
