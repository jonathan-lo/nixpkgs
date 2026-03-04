{ config, lib, pkgs, ... }:

{
  home = {
    sessionPath = lib.mkBefore [
      "/Applications/IntelliJ IDEA.app/Contents/MacOS"
      "/opt/homebrew/bin"
    ];
  };

  imports = [ ../../../home.nix ];
}
