{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, ... }:
    let
      overlay = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
    in
    {
      darwinConfigurations."JMW24PH3JT" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ({ ... }: { nixpkgs.overlays = [ overlay ]; })
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.jlo = import ./home-work.nix;
          }
          ./hosts/darwin/homebrew.nix
          ./hosts/darwin/services.nix
          ./hosts/darwin/settings.nix
        ];
      };

      homeConfigurations."DESKTOP-7RRDPPB" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ({ ... }: { nixpkgs.overlays = [ overlay ]; })
          ./home.nix
          ./hosts/linux/settings.nix
        ];
      };
      homeConfigurations."LAPTOP-GIVRN79I" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ({ ... }: { nixpkgs.overlays = [ overlay ]; })
          ./home.nix
          ./hosts/linux/settings.nix
        ];
      };
    };
}
