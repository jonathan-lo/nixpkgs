{ config, pkgs, ... }:

{
  home = {
    username = "jlo";
    homeDirectory = "/Users/jlo";
  };


  modules.shell.zsh = {
    profileExtra = ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
  };
}
