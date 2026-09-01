{ ... }:
{
  # Pinned to a nixos-unstable-small commit carrying golangci-lint 2.13.2.
  # nixos-unstable still ships 2.13.1 — the 2.13.2 bump (nixpkgs cb138f4ade3e)
  # landed 2026-08-29 and has not reached the channel yet. unstable-small is
  # Hydra-built, so this still resolves from cache.nixos.org.
  # Remove this input and go back to unstable.golangci-lint once
  # nixpkgs-unstable carries >= 2.13.2.
  flake-file.inputs.nixpkgs-golangci = {
    url = "github:nixos/nixpkgs/4951e020b824ae716cbb07d0a8f771d13a2e70e1";
  };
}
