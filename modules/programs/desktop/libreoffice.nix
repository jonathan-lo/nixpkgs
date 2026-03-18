{ ... }:
{
  flake.modules.nixos.libreoffice =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        libreoffice
      ];
    };
}
