---
type: concept
tags: [nix, flake-parts, import-tree]
---

# Architecture

The repo composes one flake from many small files using the **dendritic pattern**:
[flake-parts](https://flake.parts) + [import-tree](https://github.com/vic/import-tree) +
[flake-file](https://github.com/vic/flake-file). There is no central list of imports and
no hand-written `flake.nix`. You drop a `.nix` file under `modules/`, it self-registers
its outputs, and the flake picks it up.

## flake.nix is generated

`flake.nix` is **auto-generated — never edit it by hand** (it carries a `DO-NOT-EDIT`
header). It is produced by `flake-file` and regenerated with:

``` bash
nix run .#write-flake
```

The generator config lives in `modules/nix/flake-parts []/dendritic-tools.nix`, which
imports the flake-parts and flake-file modules and declares the generated `outputs` line:

``` nix
inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ((import inputs.import-tree) ./modules)
```

Run `write-flake` whenever you add or remove a module file, or change a flake input.

## import-tree + flake-parts

That one `outputs` line is the whole mechanism:

- `import-tree` walks `./modules` recursively and returns a flake-parts module that imports
  **every** `.nix` file it finds (dotfiles and `.gitkeep` are ignored). Dropping a file in
  the tree is all it takes to include it — there is no imports list to update.
- `flake-parts.lib.mkFlake` evaluates every discovered file as a flake-parts module and
  merges their contributions. Files that assign the same attribute path are merged, so
  several files can build up one host or one module cooperatively.
- The `flake-parts.flakeModules.modules` module (the "dendritic" piece) adds the
  `flake.modules.<class>.<name>` option namespace that modules register into.

Supporting infrastructure in `modules/nix/flake-parts []/`: `systems.nix` sets the
evaluated platforms (`x86_64-linux`, `aarch64-linux`, `aarch64-darwin`); `lib.nix` defines
the host builders used in [Hosts and Users](hosts); `factory.nix` declares the
`flake.factory` option; `darwinConfigurations-fix.nix` declares the
`flake.darwinConfigurations` option that flake-parts lacks natively.

## Self-registration and platform scope

Each file is a flake-parts module that writes into the shared registry. The **key** it
writes to is what determines platform scope:

- `flake.modules.nixos.<name>` — a NixOS system module
- `flake.modules.darwin.<name>` — a nix-darwin system module
- `flake.modules.homeManager.<name>` — a home-manager module (used on any OS)

A single file may register into more than one of these to target multiple platforms — see
[Modules](modules). Modules are then consumed **by name**, e.g. a user imports
`self.modules.homeManager.git`.

> **Legacy note — directory brackets.** Many directories still carry a `[..]` suffix
> (`git [nd]`, `services/keyd [N]`, `nix/flake-parts []`). This suffix is a **legacy,
> functionally-inert human hint** — import-tree and flake-parts never parse it, and the
> repo is moving away from it. Platform scope is decided **only** by the
> `flake.modules.<class>` key a file registers into, never by the directory name. When
> reading paths in these docs, ignore the bracket; it carries no meaning.

## Inputs are declared next to their consumers

Flake inputs are not listed centrally either. Any module can contribute inputs with a
`flake-file.inputs = { ... }` fragment, conventionally in a colocated `flake-parts.nix`.
`write-flake` collects all of them into the generated `flake.nix`. Examples:
`modules/nix/tools/nixpkgs [ND]/flake-parts.nix` (nixpkgs), `modules/programs/cli/ai
[nd]/flake-parts.nix` (`llm-agents`).

## The unstable overlay

`modules/nix/tools/nixpkgs [ND]/nixpkgs.nix` defines an overlay that imports
`nixpkgs-unstable` for the current system and exposes it as `pkgs.unstable.*`, applied on
both NixOS and darwin. Any module can then reference `pkgs.unstable.<pkg>`. The same file
declares `flake.allowedUnfreePackages` (a mergeable list) and builds the unfree predicate
reused by the home-manager builder.

See [Modules](modules) for how a single module is written and [Hosts and Users](hosts) for
how modules are assembled into a running system.
