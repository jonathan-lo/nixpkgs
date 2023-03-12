# Defaults across all my hosts and platforms (both NixOS and Darwin).
{ inputs, config, lib, pkgs, ... }:

with lib; {
  enivronment = {
    variables = {
      NIXPKGS_ALLOW_UNFREE = "1";

    };
  };
}
