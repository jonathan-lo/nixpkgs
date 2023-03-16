{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-unstable.url = "nixpkgs/master";
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, darwin, home-manager, ... }:
    let
      inherit (lib) genAttrs;
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

      pkgs = genAttrs supportedSystems.all
        (mkPkgs nixpkgs [ self.overlay ]);
      pkgsUnstable =
        genAttrs supportedSystems.all (mkPkgs nixpkgs-unstable [ ]);
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

      darwinModules = {
        dotfiles = import ./.;
      } // mapModulesRec ./modules import;
     # Default overlays usable in dependant flakes.
      overlay = _:
        { system, ... }: {
          unstable = pkgsUnstable.${system};
          my = self.packages.${system};
        };
      overlays = mapModules ./overlays import;

      packages =
        let
          mkPackages = system:
            mapModules ./packages (p: pkgs.${system}.callPackage p { });
        in
        genAttrs supportedSystems.all mkPackages;


      #darwinConfigurations =
       # mapConfigurations supportedSystems.darwin ./hosts/darwin;

      #      homeConfigurations."DESKTOP-7RRDPPB" = home-manager.lib.homeManagerConfiguration {
      #pkgs = nixpkgs.legacyPackages."x86_64-linux";
      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      #modules = [
      #          ({ ... }: { nixpkgs.overlays = [ overlay ]; })
      #          ./home.nix
      #        ];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      #      };


    };
}
