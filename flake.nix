{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      darwin,
      home-manager,
      ...
    }:
    let
      overlay = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = prev.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      };

      system = "aarch64-darwin";
      overlays = [ overlay ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
          # allowUnfreePredicate = (_: true);
        };
      };

      nixPkgsConfig = {
        inherit overlays;
      };
    in
    {
      nixosConfigurations = {
        "budu" = nixpkgs.lib.nixosSystem {

          pkgs = pkgs;
          system = "x86_64-linux";

          specialArgs = { inherit inputs; };

          modules = [
            home-manager
            {
              nixpkgs = nixPkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.users.jlo = import ./home.nix;
            }
            ./hosts/linux/budu/configuration.nix
            ./hosts/linux/budu/hardware-configuration.nix
          ];
        };
      };

      darwinConfigurations."Jonathans-MacBook-Pro" = darwin.lib.darwinSystem {
        pkgs = pkgs;
        system = "aarch64-darwin";

        specialArgs = { inherit inputs; };

        modules = [
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixPkgsConfig;
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
          ./home.nix
          ./hosts/linux/settings.nix
        ];
      };
      homeConfigurations."LAPTOP-GIVRN79I" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home.nix
          ./hosts/linux/settings.nix
        ];
      };
    };
}
