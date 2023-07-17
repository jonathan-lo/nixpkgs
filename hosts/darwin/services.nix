{ pkgs, config, ... }:

{

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      user = "jlo";
    };
  };

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-slim-16.20.1"
    ];
  nixpkgs.config.allowUnfree = true;
  users.users.jlo = {
    home = "/Users/jlo";
  };
}
