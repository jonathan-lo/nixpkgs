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
    in {
      homeConfigurations."C02XJ6XXJHD2" = home-manager.lib.homeManagerConfiguration {

        pkgs = nixpkgs.legacyPackages."x86_64-darwin";
        modules = [
#./defaults-darwin.nix
           ({ ... }: { nixpkgs.overlays = [ overlay ]; })
           ./home-mac.nix

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

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
