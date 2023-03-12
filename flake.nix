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
      inherit (lib.my) mapModules mapModulesRec mapHosts mapConfigurations;

      supportedSystems = rec {
        darwin = [ "aarch64-darwin" ];
        #linux = [ "x86_64-linux" ];
        all = darwin; #++ linux;
      };

      overlay = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };


      mkPkgs = pkgs: extraOverlays: system: import pkgs {
        inherit system;
        config.allowUnfree = true; # forgive me Stallman senpai
        overlays = extraOverlays ++ (lib.attrValues self.overlays);
      };

      pkgs = mkPkgs nixpkgs [ self.overlay ];
      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs darwin;
          lib = self;
        };
      });
    in
    {
      lib = lib.my;

      # Nix Darwin host configurations.
      darwinConfigurations =
        mapConfigurations supportedSystems.darwin ./hosts/darwin;
      
      darwinModules = mapModulesRec ./modules import;

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
