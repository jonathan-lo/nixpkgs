{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, ... }:
    let
      overlay = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
    in
    {
      darwinConfigurations."C02GW0T4Q05N" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ({ ... }: { nixpkgs.overlays = [ overlay ]; })
          home-manager.darwinModules.home-manager
          {
            home-manager.users.jlo = import ./home-mac.nix;
          }
          ./homebrew.nix
          ./services.nix
        ];
      };

      homeConfigurations."DESKTOP-7RRDPPB" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ({ ... }: { nixpkgs.overlays = [ overlay ]; })
          ./home.nix
        ];
      };
    };
}
