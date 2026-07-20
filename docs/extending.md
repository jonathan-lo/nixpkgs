---
type: guide
tags: [nix, how-to]
---

# Extending the Configuration

Task-oriented recipes for common changes. All of them rely on the discovery and
composition mechanism in [Architecture](architecture); read [Modules](modules) and
[Hosts and Users](hosts) for the concepts. Every change ends with the build-safety loop in
[Workflows and Commands](workflows).

## Add a program module

1. Copy `modules/programs/_template.nix` to a suitable place under `modules/programs/` and
   drop the leading `_` from the name.
2. Register the output key(s) for the platforms you target — `flake.modules.homeManager.<name>`
   for cross-OS home config, and/or `flake.modules.nixos.<name>` / `flake.modules.darwin.<name>`
   for system config. The key sets the platform; the directory name does not.
3. Put options under `config.settings.<name>` and opt into any unfree packages with
   `flake.allowedUnfreePackages`. If the module needs its own pinned input, add a colocated
   `flake-parts.nix` with `flake-file.inputs`.
4. Activate it by adding `<name>` to the `imports` list in `modules/users/jlo [ND]/jlo.nix`
   (or to a host's `home-manager.users.jlo.imports` for a host-only module).
5. `nix run .#write-flake` (only needed if you added an input), then `just lint` and
   `just build`.

## Add a host

1. Create `modules/hosts/<platform>/<hostname>/`.
2. Add an entry file that assigns the top-level output, e.g.
   `flake.nixosConfigurations = self.lib.mkNixos "x86_64-linux" "<hostname>";` (or
   `mkDarwin`). See the builders in [Hosts and Users](hosts).
3. Add a `configuration.nix` that targets `flake.modules.<class>.<hostname>` and imports the
   platform modules plus host-specific settings. Split hardware/user config into sibling
   files targeting the same key — they merge.
4. Add a `users/<user>.nix` importing `self.modules.<class>.<user>` and any host-only home
   modules.
5. `nix run .#write-flake`, `just lint`, `just build`.

## Add a user

Use the factory rather than duplicating account setup:

``` nix
{ self, lib, ... }:
{
  flake.modules = lib.mkMerge [
    (self.factory.user "alice" false)     # isAdmin
    { homeManager.alice = { imports = with self.modules.homeManager; [ git zsh ... ]; }; }
  ];
}
```

Then reference `self.modules.<class>.alice` from the hosts that should have the account.

## Build-safety loop

For every change: `nix run .#write-flake` (after adding/removing files or inputs) →
`just lint` → `just build` (dry-run) → `just apply`. For pure refactors, confirm the
derivation is unchanged with `/nix-drv-check`. Details in
[Workflows and Commands](workflows).
