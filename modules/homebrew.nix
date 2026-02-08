{ config, lib, ... }:

{
  home.sessionPath = lib.mkBefore [
    "/Applications/IntelliJ IDEA.app/Contents/MacOS"
    "/opt/homebrew/bin"
  ];
}
