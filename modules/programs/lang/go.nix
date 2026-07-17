{ inputs, ... }:
{
  flake.modules.homeManager.go =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        unstable.gofumpt
        unstable.gopls
        golangci-lint
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
