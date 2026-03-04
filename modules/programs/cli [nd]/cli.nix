{ inputs, ... }:
let
  systemPackages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      # base cli
      coreutils
      findutils

      # utils
      dust
      fd
      fira-code
      gnumake
      mktemp
      neofetch
      tree
    ];
  };
in
{
  flake.modules.nixos.cli = systemPackages;
  flake.modules.darwin.cli = systemPackages;

  flake.modules.homeManager.cli = { pkgs, ... }: {
    home = {
      packages = with pkgs; [
        jq
        just
        nixfmt-rfc-style
        unstable.postman
        unstable.sesh
        step-cli
        tcpdump
        yq-go
      ];
    };
  };
}
