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

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, ... }:
    let
      inherit (lib) genAttrs;
      inherit (lib.my) mapModules mapModulesRec;

      overlay = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };

      supportedSystems = rec {
        darwin = [ "x86_64-darwin" "aarch64-darwin" ];
        linux = [ "x86_64-linux" "aarch64-linux" ];
        all = darwin ++ linux;
      };

      mkPkgs = pkgs: extraOverlays: system:
        import pkgs {
          inherit system;
          overlays = extraOverlays ++ (lib.attrValues self.overlays);
        };

      pkgs = genAttrs supportedSystems.all
        (mkPkgs nixpkgs [ self.overlay ]);

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs darwin;
          lib = self;
        };
      });
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
      darwinModules = mapModulesRec ./modules import;
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
