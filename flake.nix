{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree = {
      url = "github:vic/import-tree";
      flake = false;
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      catppuccin,
      darwin,
      determinate,
      flake-parts,
      home-manager,
      ...
    }:
    let
      importTree = import inputs.import-tree;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (importTree ./modules)
      ];
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      flake =
        let
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
          # nixosConfigurations.budu is now defined in modules/hosts/budu [N]/budu.nix

          darwinConfigurations."Jonathans-MacBook-Pro" = darwin.lib.darwinSystem {
            system = "aarch64-darwin";

            specialArgs = { inherit inputs; };

            modules = [
              home-manager.darwinModules.home-manager
              {
                nixpkgs = nixPkgsConfig;
                home-manager.useGlobalPkgs = true;
                home-manager.users.jlo = {
                  imports = [
                    ./hosts/darwin/nc/home.nix
                    catppuccin.homeModules.catppuccin
                  ];
                };
              }
              ./hosts
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
              catppuccin.homeModules.catppuccin
            ];
          };
          homeConfigurations."LAPTOP-GIVRN79I" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages."x86_64-linux";
            modules = [
              ./home.nix
              ./hosts/linux/settings.nix
              catppuccin.homeModules.catppuccin
            ];
          };
        };

      perSystem = { pkgs, ... }: { };
    };
}
