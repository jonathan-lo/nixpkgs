{ pkgs, config, ... }:

{

  nix = {
    enable = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  users.users.jlo = {
    home = "/Users/jlo";
  };

  system.stateVersion = 4;
  system.primaryUser = "jlo";

  environment.systemPackages = [ pkgs.rectangle ];
}
