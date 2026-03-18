{ ... }:
{
  flake.modules.nixos.gpu =
    { pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # amd hardware acceleration
      systemd.packages = with pkgs; [ lact ];
      systemd.services.lactd.wantedBy = [ "multi-user.target" ];

      environment.systemPackages = with pkgs; [
        lact
      ];
    };
}
