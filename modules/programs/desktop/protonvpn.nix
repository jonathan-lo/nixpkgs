{ ... }:
{
  flake.modules.nixos.protonvpn =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        protonvpn-gui
      ];

      # for vpn compat
      networking.firewall.checkReversePath = false;
    };
}
