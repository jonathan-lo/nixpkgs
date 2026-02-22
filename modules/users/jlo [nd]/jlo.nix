# modules/users/jlo [nd]/jlo.nix
{ inputs, lib, ... }:
{
  # Home-manager config for jlo (shared across systems)
  flake.modules.homeManager.userJlo = { config, pkgs, ... }: {
    home.username = "jlo";
    # home.homeDirectory is system-dependent, set in host

    # Common programs, dotfiles, etc.
    # programs.git = { ... };
    # programs.zsh = { ... };
  };
}
