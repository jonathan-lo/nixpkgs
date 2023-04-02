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


  nixpkgs.config.allowUnfree = true;
  users.users.jlo = {
    home = "/Users/jlo";
  };
}
