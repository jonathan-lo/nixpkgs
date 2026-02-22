# modules/nix/tools/home-manager [ND]/home-manager.nix
{ inputs, ... }:
{
  # NixOS home-manager integration
  flake.modules.nixos.homeManagerIntegration = { ... }: {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };

  # Darwin home-manager integration
  flake.modules.darwin.homeManagerIntegration = { ... }: {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
