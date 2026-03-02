{ ... }:
{
  flake.modules.darwin.nix = { ... }: {
    nix = {
      enable = true;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };
    };
  };
}
