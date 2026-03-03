{ config, lib, pkgs, ... }:

{
  home = {
    sessionPath = lib.mkBefore [
      "/Applications/IntelliJ IDEA.app/Contents/MacOS"
      "/opt/homebrew/bin"
    ];
  };

  # ensure that both systemPackages and home manager packages are indexed in Spotlight
  targets.darwin.copyApps.enable = true;
  targets.darwin.linkApps.enable = false;

  # workaround for mac updates breaking nix
  modules.shell.zsh = {
    profileExtra = ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
  };

  imports = [ ../../../home.nix ];
}
