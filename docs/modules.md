---
type: concept
tags: [nix, home-manager, modules]
---

# Modules

A module is a single `.nix` file under `modules/` that registers one or more named outputs
into the flake registry. Most are home-manager program modules under `modules/programs/`,
grouped loosely by role (`cli`, `cloud`, `desktop`, `editor`, `lang`, `terminal`). See
[Architecture](architecture) for how they are discovered and merged.

## Anatomy

The outer function takes flake-parts arguments and assigns into `flake.modules.<class>`.
The value is itself a module function. A minimal home-manager module:

``` nix
{ inputs, ... }:
{
  flake.modules.homeManager.git =
    { config, lib, pkgs, ... }:
    let cfg = config.settings.git;
    in {
      options.settings.git = { /* mkOption declarations */ };
      config = { /* programs.git, packages, etc. */ };
    };
}
```

The registration key sets the platform. A file can register several keys to target more
than one platform — for example `modules/programs/cli/ai [nd]/ai.nix` registers **both**
`flake.modules.darwin.ai` (a system package) and `flake.modules.homeManager.ai` (the CLI
tooling). `modules/programs/_template.nix` is a copy-me scaffold showing the shape.

> **Legacy note — directory brackets.** The `[..]` suffix on directory names is a legacy,
> functionally-inert hint the repo is moving away from; platform scope comes from the
> `flake.modules.<class>` key, not the directory. See the note in
> [Architecture](architecture).

## Conventions

- **Options** are namespaced under `config.settings.<module>` with `lib.mkOption`, and
  aliased locally as `cfg`.
- **Unfree packages** are opted in per module with `flake.allowedUnfreePackages = [ ... ]`,
  consumed by the shared unfree predicate — not by a global `allowUnfree`.
- **Module-private inputs** (pins) are declared in a colocated `flake-parts.nix` via
  `flake-file.inputs`, keeping the pin documented next to its consumer. Example: the pinned
  firefox-devedition input beside `modules/programs/desktop/browsers [n]/browsers.nix`.
- **Live-editable config** uses `config.lib.file.mkOutOfStoreSymlink` to symlink a config
  directory instead of copying it into the store, so edits apply without a rebuild — see
  `modules/programs/lazyvim [nd]/lazyvim.nix`.
- **Naming** is lowercase kebab-case. The module *name* need not match the filename — e.g.
  `terraform.nix` registers `ops`, `gh-repos.nix` registers `ghRepos`.
- **The same name merges across files.** `git` is declared in both `modules/programs/git
  [nd]/git.nix` and the private `gh-repos.nix`; flake-parts merges them into one module.
  List-valued options (like `settings.git.privateOrgs`) concatenate, which lets the private
  submodule extend a public module without leaking values.

## Where modules are activated

Registering a module does not enable it. A module is only active once something imports it
by name — almost always the user config, which lists them:

``` nix
imports = with self.modules.homeManager; [ ai aws bash git lazyvim tmux zsh ... ];
```

That list lives in `modules/users/jlo [ND]/jlo.nix`. To add a module to your daily
environment you register it and add its name there — see
[Extending the Configuration](extending). How that user config attaches to each machine is
covered in [Hosts and Users](hosts).
