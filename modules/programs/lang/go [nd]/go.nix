{ inputs, ... }:
{
  flake.modules.homeManager.go =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # golangci-lint pinned via inputs.nixpkgs-golangci — see the colocated
      # flake-parts.nix for why.
      golangciPinned = import inputs.nixpkgs-golangci {
        inherit (pkgs.stdenv.hostPlatform) system;
      };
    in
    {
      home.packages = [
        pkgs.unstable.gofumpt
        pkgs.unstable.gopls
        golangciPinned.golangci-lint
      ];

      home.sessionPath = [
        "${config.home.homeDirectory}/go/bin"
      ];

      # Mark every private GitHub org as a source of private Go modules, so
      # `go`/`git` skip the public proxy and checksum DB for them.
      home.sessionVariables.GOPRIVATE = lib.concatMapStringsSep "," (
        org: "github.com/${org}/*"
      ) config.settings.git.privateOrgs;

      programs.go = {
        enable = true;
        package = pkgs.unstable.go;
      };
    };
}
