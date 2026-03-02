# Phase 4: Host Conversion

## Objective

Convert existing host configurations to use the dendritic pattern, composing features instead of defining everything inline.

## Current vs Target

### Current: budu (NixOS)

```nix
# In flake.nix
nixosConfigurations."budu" = nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [
    determinate.nixosModules.default
    home-manager.nixosModules.home-manager
    {
      nixpkgs = nixPkgsConfig;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.jlo = {
        imports = [
          ./hosts/linux/budu/home.nix
          catppuccin.homeModules.catppuccin
        ];
      };
    }
    ./hosts
    ./hosts/linux/budu/configuration.nix
  ];
};
```

### Target: budu (Dendritic)

```nix
# modules/hosts/budu [N]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.nixosConfigurations.budu = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      # Compose features
      config.flake.modules.nixos.nixpkgsConfig
      config.flake.modules.nixos.determinate
      config.flake.modules.nixos.homeManagerIntegration

      # Host-specific configuration
      ./configuration.nix
      ./hardware.nix

      # User home-manager setup
      {
        home-manager.users.jlo = {
          imports = [
            config.flake.modules.homeManager.theming
            config.flake.modules.homeManager.userJlo
            ./home.nix  # Host-specific home settings
          ];
          home.homeDirectory = "/home/jlo";
        };
      }
    ];
  };
}
```

## Step-by-Step Conversion

### 4.1 Convert budu (NixOS)

#### Create host directory structure

```bash
mkdir -p "modules/hosts/budu [N]"
```

#### `modules/hosts/budu [N]/flake-parts.nix`

```nix
# modules/hosts/budu [N]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.nixosConfigurations.budu = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      # System features
      config.flake.modules.nixos.nixpkgsConfig
      config.flake.modules.nixos.determinate
      config.flake.modules.nixos.homeManagerIntegration

      # Host-specific
      ./configuration.nix
      ./hardware.nix

      # Users
      {
        home-manager.users.jlo = {
          imports = [
            config.flake.modules.homeManager.theming
            config.flake.modules.homeManager.userJlo
            ./home.nix
          ];
          home.homeDirectory = "/home/jlo";
          home.stateVersion = "24.05";  # Or your version
        };
      }
    ];
  };
}
```

#### Move host files

```bash
# Move existing host files into the new location
cp hosts/linux/budu/configuration.nix "modules/hosts/budu [N]/"
cp hosts/linux/budu/home.nix "modules/hosts/budu [N]/"
# Also copy hardware-configuration.nix if separate
```

#### Clean up moved files

Edit `modules/hosts/budu [N]/configuration.nix` to remove:
- Anything now handled by features (nixpkgs config, determinate import)
- Keep only host-specific settings (hostname, hardware, services specific to this machine)

Edit `modules/hosts/budu [N]/home.nix` to remove:
- Catppuccin import (now in theming feature)
- Common settings moved to `userJlo` feature
- Keep only budu-specific home settings

### 4.2 Convert Jonathans-MacBook-Pro (Darwin)

#### `modules/hosts/macbook [D]/flake-parts.nix`

```nix
# modules/hosts/macbook [D]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.darwinConfigurations."Jonathans-MacBook-Pro" = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = { inherit inputs; };
    modules = [
      # System features
      config.flake.modules.darwin.nixpkgsConfig
      config.flake.modules.darwin.homeManagerIntegration

      # Host-specific Darwin settings
      ./configuration.nix
      ./homebrew.nix
      ./services.nix
      ./settings.nix

      # Users
      {
        home-manager.users.jlo = {
          imports = [
            config.flake.modules.homeManager.theming
            config.flake.modules.homeManager.userJlo
            ./home.nix
          ];
          home.homeDirectory = "/Users/jlo";
          home.stateVersion = "24.05";
        };
      }
    ];
  };
}
```

#### Move host files

```bash
mkdir -p "modules/hosts/macbook [D]"
cp hosts/darwin/nc/home.nix "modules/hosts/macbook [D]/"
cp hosts/darwin/homebrew.nix "modules/hosts/macbook [D]/"
cp hosts/darwin/services.nix "modules/hosts/macbook [D]/"
cp hosts/darwin/settings.nix "modules/hosts/macbook [D]/"
# Create configuration.nix for any remaining darwin config
```

### 4.3 Convert WSL Hosts (Standalone Home-Manager)

#### `modules/hosts/wsl-desktop [n]/flake-parts.nix`

```nix
# modules/hosts/wsl-desktop [n]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.homeConfigurations."DESKTOP-7RRDPPB" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    extraSpecialArgs = { inherit inputs; };
    modules = [
      # Compose home-manager features
      config.flake.modules.homeManager.theming
      config.flake.modules.homeManager.userJlo

      # Host-specific
      ./home.nix

      {
        home.homeDirectory = "/home/jlo";
        home.stateVersion = "24.05";
      }
    ];
  };
}
```

#### `modules/hosts/wsl-laptop [n]/flake-parts.nix`

```nix
# modules/hosts/wsl-laptop [n]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.homeConfigurations."LAPTOP-GIVRN79I" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    extraSpecialArgs = { inherit inputs; };
    modules = [
      config.flake.modules.homeManager.theming
      config.flake.modules.homeManager.userJlo
      ./home.nix
      {
        home.homeDirectory = "/home/jlo";
        home.stateVersion = "24.05";
      }
    ];
  };
}
```

### 4.4 Remove Old Definitions from flake.nix

After hosts are defined in modules, remove them from `flake.nix`:

```nix
# flake.nix - after migration
{
  inputs = { /* ... */ };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (import inputs.import-tree ./modules)
      ];

      # The flake attribute is now empty or minimal
      # All configurations come from modules/hosts/*/flake-parts.nix
      flake = { };

      perSystem = { pkgs, ... }: {
        # devShells, packages, etc.
      };
    };
}
```

## Host File Cleanup

### What to keep in host-specific files

| File | Keep | Remove |
|------|------|--------|
| `configuration.nix` | hostname, hardware specifics, host-only services | nixpkgs config, home-manager import |
| `home.nix` | host-specific paths, host-only programs | catppuccin, common dotfiles |
| `hardware.nix` | All (hardware is always host-specific) | Nothing |

### Example cleaned configuration.nix

```nix
# modules/hosts/budu [N]/configuration.nix
{ config, pkgs, ... }:
{
  # Host identity
  networking.hostName = "budu";

  # Hardware-specific
  boot.loader.systemd-boot.enable = true;

  # Services only on this host
  services.openssh.enable = true;

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    # packages only needed on budu
  ];

  system.stateVersion = "24.05";
}
```

## Incremental Migration Strategy

Don't convert all hosts at once. Migrate one at a time:

1. **Convert budu** → Test with `nixos-rebuild dry-build --flake .#budu`
2. **Remove budu from old flake.nix** → Verify it still builds
3. **Convert macbook** → Test with `darwin-rebuild build --flake .#Jonathans-MacBook-Pro`
4. **Convert WSL hosts** → Test with `home-manager build --flake .#DESKTOP-7RRDPPB`

## Validation Commands

```bash
# List all configurations (should show hosts from modules now)
nix flake show

# Test NixOS
nixos-rebuild dry-build --flake .#budu

# Test Darwin
darwin-rebuild build --flake .#Jonathans-MacBook-Pro --dry-run

# Test home-manager
home-manager build --flake .#DESKTOP-7RRDPPB --dry-run

# Check for evaluation errors
nix flake check
```

## Troubleshooting

### "attribute 'modules' not found"

The feature module isn't being imported. Check:
- File exists and doesn't start with `_`
- File is valid Nix syntax
- `flake.modules.<class>.<name>` is defined

### "infinite recursion"

A module imports itself or creates a cycle. Check:
- No circular imports between features
- Don't import a module class from within itself

### Config option conflicts

Two features set the same option. Use `lib.mkForce` or `lib.mkDefault`:

```nix
{
  programs.zsh.enable = lib.mkDefault true;  # Can be overridden
}
```

## Files Changed This Phase

```
modules/hosts/
├── budu [N]/
│   ├── flake-parts.nix      # NEW: host definition
│   ├── configuration.nix    # MOVED & CLEANED
│   ├── hardware.nix         # MOVED
│   └── home.nix             # MOVED & CLEANED
├── macbook [D]/
│   ├── flake-parts.nix      # NEW
│   ├── configuration.nix    # NEW (extracted from flake.nix)
│   ├── homebrew.nix         # MOVED
│   ├── services.nix         # MOVED
│   ├── settings.nix         # MOVED
│   └── home.nix             # MOVED & CLEANED
├── wsl-desktop [n]/
│   ├── flake-parts.nix      # NEW
│   └── home.nix             # MOVED
└── wsl-laptop [n]/
    ├── flake-parts.nix      # NEW
    └── home.nix             # MOVED

flake.nix                    # CLEANED (removed inline configs)
hosts/                       # CAN DELETE after migration verified
```

## Checkpoint

At this point:
- [x] All hosts defined in `modules/hosts/*/flake-parts.nix`
- [x] Hosts compose features via `config.flake.modules.<class>.<name>`
- [x] No inline configurations in `flake.nix`
- [x] All hosts build successfully

## Next

[05-helpers-and-utilities.md](./05-helpers-and-utilities.md) - Create helper functions for cleaner host definitions
