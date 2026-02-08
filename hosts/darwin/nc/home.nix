{ config, lib, pkgs, ... }:

{
  home = {
    packages = with pkgs; [
    ];
    sessionPath = lib.mkBefore [
      "/Applications/IntelliJ IDEA.app/Contents/MacOS"
      "/opt/homebrew/bin"
    ];
  };

  modules.java.enable = true;

  # workaround for mac updates breaking nix
  modules.shell.zsh = {
    profileExtra = ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
  };

  imports = [ ../../../home.nix ];
}
