---
type: concept
tags: [nix, hosts, home-manager]
---

# Hosts and Users

A host is a concrete machine that produces a top-level flake output
(`darwinConfigurations`, `nixosConfigurations`, or `homeConfigurations`). Hosts assemble
named [modules](modules) into a running system through two helpers: the **library
builders** and the **user factory**.

## Library builders

`modules/nix/flake-parts []/lib.nix` defines three curried `system: name:` builders under
`self.lib`. Each pulls the aggregated `self.modules.<class>.<name>` module and wraps it into
a real system:

- `mkNixos system name` → `nixpkgs.lib.nixosSystem` with `self.modules.nixos.<name>`
- `mkDarwin system name` → `darwin.lib.darwinSystem` with `self.modules.darwin.<name>`
- `mkHomeManager system name` → `home-manager.lib.homeManagerConfiguration` with
  `self.modules.homeManager.<name>`

Each returns `{ ${name} = <builtSystem>; }`, so a host file assigns it straight into the
matching `*Configurations` output. The host module itself (`self.modules.<class>.<name>`)
is built up across several files that all target the same key.

## The user factory

`modules/factory/user [ND]/user.nix` defines `self.factory.user`, a curried
`username: isAdmin:` function returning `{ nixos.<user>; darwin.<user>; homeManager.<user>; }`.
It creates the OS account on each platform (home dir, zsh, `wheel`/`primaryUser` when
admin) and — crucially — wires `home-manager.users.<user>.imports = [
self.modules.homeManager.<user> ]`, bridging the system account to a home-manager module
named after the user.

`modules/users/jlo [ND]/jlo.nix` uses it:

``` nix
flake.modules = lib.mkMerge [
  (self.factory.user "jlo" true)          # admin
  {
    nixos.jlo = { users.users.jlo.extraGroups = [ "docker" "networkmanager" ]; };
    homeManager.jlo = { ... }: {
      imports = with self.modules.homeManager; [ ai aws bash git lazyvim tmux zsh ... ];
      home.stateVersion = "22.05";
    };
  }
];
```

So `homeManager.jlo` is the aggregate that imports every active program module; the factory
attaches it to each machine.

## The three hosts

- **macOS / nix-darwin** — `modules/hosts/darwin [D]/nc/`. `macbook.nix` sets
  `flake.darwinConfigurations = self.lib.mkDarwin "aarch64-darwin" "Jonathans-MacBook-Pro"`.
  `configuration.nix` imports the darwin modules; `users/jlo.nix` imports the factory's
  darwin `jlo` account plus any host-specific home modules.
- **NixOS** — `modules/hosts/linux [N]/budu/`. `budu.nix` sets `flake.nixosConfigurations =
  self.lib.mkNixos "x86_64-linux" "budu"`. `configuration.nix` imports the nixos modules and
  sets bootloader/networking/locale; `flake-parts.nix` pulls in
  `_hardware-configuration.nix`; `users/jlo.nix` adds `bitwarden` and `calibre` on top of
  the shared home config. (`README.md` there is a generated dependency graph.)
- **WSL** — `modules/hosts/wsl []/wsl.nix`. **Structurally different**: a standalone
  home-manager config built directly with `home-manager.lib.homeManagerConfiguration`
  (no system layer, no factory, no `mkHomeManager`). It emits `flake.homeConfigurations`
  keyed by machine hostname. Note it currently pulls in **only** `home.username` +
  catppuccin — it does *not* import the shared `jlo` home config.

## End-to-end trace (budu)

1. `budu.nix` → `flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" "budu"`.
2. `mkNixos` → `nixosSystem { modules = [ self.modules.nixos.budu, { hostPlatform } ]; }`.
3. `self.modules.nixos.budu` is the merge of every fragment targeting that key:
   `configuration.nix` (module imports + system settings), `flake-parts.nix` (hardware),
   `users/jlo.nix` (imports `self.modules.nixos.jlo`, adds bitwarden/calibre).
4. `self.modules.nixos.jlo` is the factory's nixos user (account + `home-manager.users.jlo.imports
   = [ self.modules.homeManager.jlo ]`) merged with the extra `docker`/`networkmanager` groups.
5. `self.modules.homeManager.jlo` imports the full list of program [modules](modules).
6. Result: `nixosConfigurations.budu`, applied via `just apply` — see
   [Workflows and Commands](workflows).

To add a host or user, see [Extending the Configuration](extending).
