{ config, pkgs, ... }:

{
  home = {
    username = "jlo";
    homeDirectory = "/Users/jlo";
  };

  settings = {
    alacritty.fontName = "FuraMono Nerd Font Mono";
    zsh.profileExtra = ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";
  };
}
