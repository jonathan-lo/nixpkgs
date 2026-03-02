# Phase 5: Helpers and Utilities

## Objective

Create helper functions (`mkNixos`, `mkDarwin`, `mkHome`) to reduce boilerplate in host definitions.

## The Problem

Host definitions have repetitive structure:

```nix
# Every NixOS host looks like this:
flake.nixosConfigurations.hostname = inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    config.flake.modules.nixos.nixpkgsConfig
    config.flake.modules.nixos.homeManagerIntegration
    # ... more boilerplate ...
  ];
};
```

## The Solution: Factory Functions

### 5.1 Define Helper Functions

#### `modules/nix/flake-parts []/lib.nix`

```nix
# modules/nix/flake-parts []/lib.nix
{ inputs, config, lib, ... }:
let
  # Common modules applied to ALL NixOS hosts
  defaultNixosModules = [
    config.flake.modules.nixos.nixpkgsConfig
    config.flake.modules.nixos.homeManagerIntegration
  ];

  # Common modules applied to ALL Darwin hosts
  defaultDarwinModules = [
    config.flake.modules.darwin.nixpkgsConfig
    config.flake.modules.darwin.homeManagerIntegration
  ];

  # Common home-manager modules applied to ALL users
  defaultHomeModules = [
    config.flake.modules.homeManager.theming
  ];

  # Helper: Create a NixOS configuration
  mkNixos = system: hostname: { modules ? [ ], users ? { }, ... }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = defaultNixosModules ++ modules ++ [
        {
          networking.hostName = hostname;
          home-manager.users = lib.mapAttrs (username: userCfg: {
            imports = defaultHomeModules ++ (userCfg.modules or [ ]);
            home.homeDirectory = userCfg.homeDirectory or "/home/${username}";
            home.stateVersion = userCfg.stateVersion or "24.05";
          }) users;
        }
      ];
    };

  # Helper: Create a Darwin configuration
  mkDarwin = system: hostname: { modules ? [ ], users ? { }, ... }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = defaultDarwinModules ++ modules ++ [
        {
          networking.hostName = hostname;
          home-manager.users = lib.mapAttrs (username: userCfg: {
            imports = defaultHomeModules ++ (userCfg.modules or [ ]);
            home.homeDirectory = userCfg.homeDirectory or "/Users/${username}";
            home.stateVersion = userCfg.stateVersion or "24.05";
          }) users;
        }
      ];
    };

  # Helper: Create a standalone home-manager configuration
  mkHome = system: { modules ? [ ], username, homeDirectory, stateVersion ? "24.05" }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      extraSpecialArgs = { inherit inputs; };
      modules = defaultHomeModules ++ modules ++ [
        {
          home.username = username;
          home.homeDirectory = homeDirectory;
          home.stateVersion = stateVersion;
        }
      ];
    };
in
{
  # Export helpers via flake.lib
  flake.lib = {
    inherit mkNixos mkDarwin mkHome;
  };
}
```

### 5.2 Simplified Host Definitions

With helpers, hosts become much cleaner:

#### `modules/hosts/budu [N]/flake-parts.nix`

```nix
# modules/hosts/budu [N]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.nixosConfigurations.budu = inputs.self.lib.mkNixos "x86_64-linux" "budu" {
    modules = [
      config.flake.modules.nixos.determinate
      ./configuration.nix
      ./hardware.nix
    ];
    users.jlo = {
      modules = [
        config.flake.modules.homeManager.userJlo
        ./home.nix
      ];
    };
  };
}
```

#### `modules/hosts/macbook [D]/flake-parts.nix`

```nix
# modules/hosts/macbook [D]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.darwinConfigurations."Jonathans-MacBook-Pro" = inputs.self.lib.mkDarwin "aarch64-darwin" "Jonathans-MacBook-Pro" {
    modules = [
      ./configuration.nix
      ./homebrew.nix
      ./services.nix
      ./settings.nix
    ];
    users.jlo = {
      modules = [
        config.flake.modules.homeManager.userJlo
        ./home.nix
      ];
    };
  };
}
```

#### `modules/hosts/wsl-desktop [n]/flake-parts.nix`

```nix
# modules/hosts/wsl-desktop [n]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.homeConfigurations."DESKTOP-7RRDPPB" = inputs.self.lib.mkHome "x86_64-linux" {
    username = "jlo";
    homeDirectory = "/home/jlo";
    modules = [
      config.flake.modules.homeManager.userJlo
      ./home.nix
    ];
  };
}
```

## Advanced Helpers

### 5.3 Feature Toggle Helper

Enable/disable features per host:

```nix
# In lib.nix, add:
  # Helper: Conditionally include modules based on feature flags
  withFeatures = features: moduleMap:
    lib.filter (m: m != null) (
      lib.mapAttrsToList (name: enabled:
        if enabled then moduleMap.${name} or null else null
      ) features
    );
```

Usage:

```nix
# In a host definition
modules = inputs.self.lib.withFeatures {
  gaming = true;
  docker = true;
  virtualbox = false;
} {
  gaming = config.flake.modules.nixos.gaming;
  docker = config.flake.modules.nixos.docker;
  virtualbox = config.flake.modules.nixos.virtualbox;
};
```

### 5.4 Multi-User Helper

For hosts with multiple users:

```nix
# modules/hosts/homeserver [N]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.nixosConfigurations.homeserver = inputs.self.lib.mkNixos "x86_64-linux" "homeserver" {
    modules = [
      ./configuration.nix
      ./hardware.nix
    ];
    users = {
      alice = {
        modules = [
          config.flake.modules.homeManager.userAlice
        ];
      };
      bob = {
        modules = [
          config.flake.modules.homeManager.userBob
        ];
      };
    };
  };
}
```

### 5.5 Host Metadata Helper

Store host metadata for use across the flake:

```nix
# modules/nix/flake-parts []/hosts-meta.nix
{ lib, ... }:
{
  options.flake.hostsMeta = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        system = lib.mkOption { type = lib.types.str; };
        type = lib.mkOption { type = lib.types.enum [ "nixos" "darwin" "home" ]; };
        users = lib.mkOption { type = lib.types.listOf lib.types.str; default = [ ]; };
      };
    });
    default = { };
    description = "Metadata about all hosts";
  };

  # Hosts register themselves:
  config.flake.hostsMeta.budu = {
    system = "x86_64-linux";
    type = "nixos";
    users = [ "jlo" ];
  };
}
```

## Factory Module Pattern

For very common host types, create factory modules:

### `modules/factory/nixos-desktop [N]/nixos-desktop.nix`

```nix
# modules/factory/nixos-desktop [N]/nixos-desktop.nix
# Factory for standard NixOS desktop hosts
{ inputs, config, lib, ... }:
let
  mkDesktop = hostname: system: extraModules: users:
    inputs.self.lib.mkNixos system hostname {
      modules = [
        config.flake.modules.nixos.desktop  # Desktop environment
        config.flake.modules.nixos.audio    # Pipewire/Pulseaudio
        config.flake.modules.nixos.fonts    # System fonts
        config.flake.modules.nixos.printing # CUPS
      ] ++ extraModules;
      inherit users;
    };
in
{
  flake.lib.mkDesktop = mkDesktop;
}
```

Usage:

```nix
# modules/hosts/budu [N]/flake-parts.nix
{ inputs, config, ... }:
{
  flake.nixosConfigurations.budu = inputs.self.lib.mkDesktop "budu" "x86_64-linux"
    [ ./hardware.nix ]
    {
      jlo.modules = [ config.flake.modules.homeManager.userJlo ];
    };
}
```

## Summary of Helpers

| Helper | Purpose |
|--------|---------|
| `mkNixos` | Create NixOS configuration with defaults |
| `mkDarwin` | Create Darwin configuration with defaults |
| `mkHome` | Create standalone home-manager configuration |
| `withFeatures` | Conditionally include modules |
| `mkDesktop` | Factory for desktop NixOS hosts |

## Files Created/Modified

```
modules/nix/flake-parts []/
├── lib.nix              # MODIFIED: Added helpers
└── hosts-meta.nix       # NEW: Optional host metadata

modules/factory/         # NEW: Optional factory modules
└── nixos-desktop [N]/
    └── nixos-desktop.nix
```

## Checkpoint

At this point:
- [x] Helper functions reduce host boilerplate
- [x] Default modules applied automatically
- [x] Easy to add new hosts with minimal code
- [x] Factories available for common host patterns

## Next

[06-testing-and-validation.md](./06-testing-and-validation.md) - Validate the complete migration
