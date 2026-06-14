{ ... }:
{
  flake.modules.nixos.protonvpn =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        proton-vpn
      ];

      # for vpn compat
      networking.firewall.checkReversePath = false;
    };
}
