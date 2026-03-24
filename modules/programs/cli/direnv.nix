{ inputs, ... }:
{
  flake.modules.homeManager.direnv =
    { pkgs, ... }:
    {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
        # direnv's Makefile passes -linkmode=external which requires cgo,
        # but the nixpkgs derivation sets CGO_ENABLED=0, causing the build to fail.
        package = pkgs.direnv.overrideAttrs (old: {
          env = (old.env or { }) // { CGO_ENABLED = "1"; };
        });
      };
    };
}
