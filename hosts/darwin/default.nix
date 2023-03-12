# Defaults across all my Darwin hosts.
{ ... }: {
  # Keep for nix-darwin backwards compatibility.
  system.stateVersion = 4;

  services.nix-daemon.enable = false; # hack for internal

}
