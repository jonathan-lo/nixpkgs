{ inputs, ... }:
let
  systemPackages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        # base cli
        coreutils
        findutils
        unixtools.net-tools

        # utils
        dust
        fd
        gnumake
        mktemp
        neofetch
        unstable.nixoscope
        tree
      ];
    };
in
{
  flake.modules.nixos.cli = systemPackages;
  flake.modules.darwin.cli = systemPackages;

  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          jq
          just
          nixfmt-rfc-style
          step-cli
          tcpdump
          yq-go
        ];
      };
    };
}
