---
type: reference
tags: [nix, commands, just]
---

# Workflows and Commands

Day-to-day commands. Most are `just` recipes (`justfile`); `rebuild` is dispatched per OS
(`nixos-rebuild` on Linux, `darwin-rebuild` on macOS, `home-manager` on WSL). The
[Extending](extending) guide references the build-safety loop defined here.

## Just recipes

| Command | What it does |
| --- | --- |
| `just apply` | Rebuild and switch the active system for the current OS. On macOS uses `git+file:.?submodules=1` so the private submodule is included. |
| `just build` | macOS dry-run build of the darwin system — validates without switching. |
| `just lint` | Format every `.nix` file with `nixfmt`. All committed code must pass. |
| `just update` | `nix flake update` — refresh `flake.lock`. Review the diff before committing. |
| `just prime` | macOS: warm root's fetch cache for private inputs using a short-lived `gh` token passed via process env only. Run once, and again after bumping a pinned private rev. |
| `just package-graph` | Linux: regenerate the `budu` module dependency graph (`README.md`). |
| `just system-info` | Print the detected OS. |

## Flake regeneration

`flake.nix` is generated — never edit it directly. Regenerate after adding/removing a
module file or changing an input:

``` bash
nix run .#write-flake
```

See [Architecture](architecture) for why and how.

## Refactor safety

`/nix-drv-check` (a Claude Code command) compares the derivation before and after staged
changes. A pure refactor MUST leave the derivation identical. Use it whenever you move or
restructure modules without intending a behavior change.

## The loop

`write-flake` (if files/inputs changed) → `just lint` → `just build` → `just apply`, with
`/nix-drv-check` for refactors. This mirrors the project constitution's Build Safety
principle.
