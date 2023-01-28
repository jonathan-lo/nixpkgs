{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.settings.bash;
in {
  config.programs.bash = {
    enable = true;
    historyControl = [ "erasedups" "ignoredups" "ignorespace" ];
    historyIgnore = [ "cd" "exit" "history" "l" "ll" "ls" "pwd"  ];
    profileExtra = ". /home/jlo/.nix-profile/etc/profile.d/nix.sh";
  };
}
