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

  users.users.jlo = {
    home = "/Users/jlo";
  };

  system.stateVersion = 5;
  system.primaryUser = "jlo";

  environment.systemPackages = with pkgs; [
    coreutils
    findutils
    logseq
    rectangle
  ];
}
