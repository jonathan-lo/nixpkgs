{ pkgs, config, ... }:

{

  users.users.jlo = {
    home = "/Users/jlo";
  };

  system.stateVersion = 5;
  system.primaryUser = "jlo";

  environment.systemPackages = with pkgs; [
    logseq
  ];
}
