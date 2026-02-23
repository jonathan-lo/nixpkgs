# modules/hosts/budu [N]/budu.nix
{ inputs, config, ... }:
let
  catppuccin = inputs.catppuccin;
  determinate = inputs.determinate;
  home-manager = inputs.home-manager;
  nixpkgs = inputs.nixpkgs;

  overlay = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  nixPkgsConfig = {
    overlays = [ overlay ];
    config.allowUnfree = true;
  };
in
{
  flake.nixosConfigurations.budu = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      determinate.nixosModules.default
      home-manager.nixosModules.home-manager
      {
        nixpkgs = nixPkgsConfig;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.jlo.imports = with config.flake.modules.homeManager; [
          ../../../hosts/linux/budu/home.nix
          catppuccin.homeModules.catppuccin
          ai
          aws
        ];
      }
      ../../../hosts
      ../../../hosts/linux/budu/configuration.nix
    ];
  };
}
