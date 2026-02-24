{ inputs, config, ... }:
let
  inherit (inputs) darwin home-manager catppuccin;

  overlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  overlays = [ overlay ];

  nixPkgsConfig = {
    inherit overlays;
    config.allowUnfree = true;
  };
in
{
  flake.darwinConfigurations."Jonathans-MacBook-Pro" = darwin.lib.darwinSystem {
    system = "aarch64-darwin";

    specialArgs = { inherit inputs; };

    modules = [
      home-manager.darwinModules.home-manager
      {
        nixpkgs = nixPkgsConfig;
        home-manager.useGlobalPkgs = true;
        home-manager.users.jlo.imports = with config.flake.modules.homeManager; [
          ../../../hosts/darwin/nc/home.nix
          catppuccin.homeModules.catppuccin
          ai
          aws
          bash
        ];
      }
      ../../../hosts
      ../../../hosts/darwin/homebrew.nix
      ../../../hosts/darwin/services.nix
      ../../../hosts/darwin/settings.nix
    ];
  };
}
