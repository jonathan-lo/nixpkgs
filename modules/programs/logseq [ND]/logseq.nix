{ ... }:
{
  flake.modules.nixos.logseq =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        logseq
      ];
    };

  flake.modules.darwin.logseq =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        logseq
      ];
    };
}
