{
  inputs,
  ...
}:
{
  # Manage a user environment using Nix
  # https://github.com/nix-community/home-manager

  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake-file.inputs = {
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
}
