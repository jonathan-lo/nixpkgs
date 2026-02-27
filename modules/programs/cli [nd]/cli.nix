{ inputs, ... }:
{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    home = {
      packages = with pkgs; [
        jq
        just
        nixfmt-rfc-style
        postman
        unstable.sesh
        step-cli
        tcpdump
        yq-go
      ];
    };
  };
}
