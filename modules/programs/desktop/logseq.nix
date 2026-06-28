{ ... }:
{
  # darwin installs logseq via the homebrew cask instead — its from-source
  # nixpkgs build (shadow-cljs release) deadlocks and does not produce a binary.
  flake.modules.nixos.logseq =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        logseq
      ];
    };
}
