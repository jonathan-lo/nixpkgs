{ ... }:
{
  # Pinned to the release-25.11 commit immediately before firefox-devedition
  # was bumped to 152.0b1, which fails to build on darwin: it references the
  # WebAuthn `prf` extension property on AuthenticationServices classes that
  # the macOS SDK does not yet expose at the deployment target nixpkgs sets.
  # Revisit once nixpkgs ships a working firefox-devedition on aarch64-darwin.
  flake-file.inputs.nixpkgs-firefox-devedition = {
    url = "github:nixos/nixpkgs/ea1d480338c301fb20b067a155d6cba71a65b406";
  };
}
