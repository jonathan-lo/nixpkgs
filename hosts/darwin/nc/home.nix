
{ config, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
    ];
  };

  modules.java.enable = true;


  # workaround for mac updates breaking nix
  modules.shell.zsh = {
    profileExtra = ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
  };

  imports = [ ../../../home.nix ];
}
