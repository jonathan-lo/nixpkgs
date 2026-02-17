# Phase 3: Feature Extraction

## Objective

Extract repeated patterns from your current flake into reusable feature modules.

## Inventory of Current Patterns

From your existing `flake.nix`, these patterns are repeated or could be shared:

| Pattern | Current Location | Occurrences | Target Feature |
|---------|------------------|-------------|----------------|
| Unstable overlay | flake.nix let block | 1 (shared) | `system/nixpkgs` |
| allowUnfree | flake.nix let block | 1 (shared) | `system/nixpkgs` |
| Catppuccin import | Each host's home-manager | 4 | `programs/theming` |
| home-manager setup | Each host | 3 | `users/jlo` or host-level |
| determinate module | NixOS hosts | 1 | `system/determinate` |

## Feature Modules to Create

### 3.1 Nixpkgs Configuration

#### `modules/system/nixpkgs [ND]/nixpkgs.nix`

Handles overlays and nixpkgs settings for all systems:

```nix
# modules/system/nixpkgs [ND]/nixpkgs.nix
{ inputs, ... }:
let
  # Overlay to add unstable packages
  unstableOverlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
in
{
  # NixOS system-level nixpkgs config
  flake.modules.nixos.nixpkgsConfig = { ... }: {
    nixpkgs.overlays = [ unstableOverlay ];
    nixpkgs.config.allowUnfree = true;
  };

  # Darwin system-level nixpkgs config
  flake.modules.darwin.nixpkgsConfig = { ... }: {
    nixpkgs.overlays = [ unstableOverlay ];
    nixpkgs.config.allowUnfree = true;
  };
}
```

### 3.2 Theming (Catppuccin)

#### `modules/programs/theming [nd]/theming.nix`

```nix
# modules/programs/theming [nd]/theming.nix
{ inputs, ... }:
{
  # Home-manager theming for any OS
  flake.modules.homeManager.theming = { ... }: {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    # Enable catppuccin globally
    catppuccin = {
      enable = true;
      flavor = "mocha";  # or make this configurable
    };
  };
}
```

### 3.3 Determinate Nix

#### `modules/system/determinate [N]/determinate.nix`

```nix
# modules/system/determinate [N]/determinate.nix
{ inputs, ... }:
{
  flake.modules.nixos.determinate = { ... }: {
    imports = [ inputs.determinate.nixosModules.default ];
  };
}
```

### 3.4 User: jlo

#### `modules/users/jlo [nd]/jlo.nix`

Common home-manager settings for user jlo across all systems:

```nix
# modules/users/jlo [nd]/jlo.nix
{ inputs, lib, ... }:
{
  # Home-manager config for jlo (shared across systems)
  flake.modules.homeManager.userJlo = { config, pkgs, ... }: {
    home.username = "jlo";
    # home.homeDirectory is system-dependent, set in host

    # Import theming
    imports = [
      # Reference other home-manager modules
    ];

    # Common programs, dotfiles, etc.
    # programs.git = { ... };
    # programs.zsh = { ... };
  };
}
```

### 3.5 Home-Manager Integration

#### `modules/system/home-manager [ND]/home-manager.nix`

```nix
# modules/system/home-manager [ND]/home-manager.nix
{ inputs, ... }:
{
  # NixOS home-manager integration
  flake.modules.nixos.homeManagerIntegration = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };

  # Darwin home-manager integration
  flake.modules.darwin.homeManagerIntegration = { ... }: {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
```

## Extracting from Existing Host Files

You'll need to examine your existing host files to extract more features:

### Analyze Current Host Files

```bash
# List what's in your host directories
ls -la hosts/
ls -la hosts/linux/budu/
ls -la hosts/darwin/
```

Common extractions:

| If you have... | Extract to... |
|----------------|---------------|
| Shell config (zsh, bash) | `modules/programs/shell [nd]/` |
| Editor config (neovim, emacs) | `modules/programs/editor [nd]/` |
| Git config | `modules/programs/git [nd]/` |
| Desktop environment | `modules/programs/desktop [N]/` |
| Fonts | `modules/system/fonts [ND]/` |
| Networking | `modules/system/networking [N]/` |

### Example: Extracting Shell Config

If `hosts/linux/budu/home.nix` has:

```nix
{
  programs.zsh = {
    enable = true;
    # lots of config...
  };
}
```

Create `modules/programs/shell [nd]/shell.nix`:

```nix
{ inputs, ... }:
{
  flake.modules.homeManager.shell = { config, pkgs, ... }: {
    programs.zsh = {
      enable = true;
      # all the config from hosts/linux/budu/home.nix
    };
  };
}
```

## Module Composition Pattern

Features can import other features:

```nix
# modules/programs/dev-environment [nd]/dev-environment.nix
{ inputs, config, ... }:
{
  flake.modules.homeManager.devEnvironment = { ... }: {
    imports = [
      # Compose from other home-manager modules
      config.flake.modules.homeManager.shell
      config.flake.modules.homeManager.editor
      config.flake.modules.homeManager.git
    ];

    # Additional dev-specific settings
    home.packages = with pkgs; [
      ripgrep
      fd
      jq
    ];
  };
}
```

## Conditional Features

Use `lib.mkIf` for OS-specific settings within a feature:

```nix
# modules/programs/clipboard [nd]/clipboard.nix
{ inputs, ... }:
{
  flake.modules.homeManager.clipboard = { config, pkgs, lib, ... }: {
    home.packages = lib.mkMerge [
      # Linux clipboard tools
      (lib.mkIf pkgs.stdenv.isLinux [
        pkgs.xclip
        pkgs.wl-clipboard
      ])
      # macOS has pbcopy/pbpaste built-in, but add extras
      (lib.mkIf pkgs.stdenv.isDarwin [
        pkgs.reattach-to-user-namespace
      ])
    ];
  };
}
```

## Testing Features in Isolation

Before integrating into hosts, test that features are valid:

```bash
# Check that the flake evaluates without errors
nix flake check

# Check specific module exists
nix eval .#modules.homeManager.theming --apply 'x: "exists"'
```

## Files Created This Phase

```
modules/
├── system/
│   ├── nixpkgs [ND]/nixpkgs.nix
│   ├── determinate [N]/determinate.nix
│   └── home-manager [ND]/home-manager.nix
├── programs/
│   └── theming [nd]/theming.nix
└── users/
    └── jlo [nd]/jlo.nix
```

## Migration Checklist

For each feature:
- [ ] Identify repeated pattern in current flake
- [ ] Create feature module in appropriate location
- [ ] Define `flake.modules.<class>.<name>` for each context
- [ ] Test that module evaluates correctly
- [ ] Document any configuration options

## Checkpoint

At this point:
- [x] Core features extracted into modules
- [x] Modules define `flake.modules.<class>.<name>`
- [x] Features can be composed
- [x] Existing configs still work (haven't changed hosts yet)

## Next

[04-host-conversion.md](./04-host-conversion.md) - Convert hosts to use the extracted features
