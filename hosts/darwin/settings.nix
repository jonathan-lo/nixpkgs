{ config, pkgs, ... }:

{
  home = {
    username = "jlo";
    homeDirectory = "/Users/jlo";
  };

  settings = {
    alacritty.fontName = "FiraMono Nerd Font Mono";
  };


  modules.shell.zsh = {
    profileExtra = ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
  };
}
