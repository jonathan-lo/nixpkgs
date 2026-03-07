{ ... }:
{
  flake.modules.darwin.logseq =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        logseq
      ];
    };
}
