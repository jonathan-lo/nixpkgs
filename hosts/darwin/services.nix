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

  services = {
    nix-daemon.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  users.users.jlo = {
    home = "/Users/jlo";
  };

  system.stateVersion = 4;
}
