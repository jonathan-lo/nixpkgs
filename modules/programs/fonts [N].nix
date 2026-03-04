{ ... }:
{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts.fontconfig.enable = true;

    environment.systemPackages = with pkgs; [
      fira-code
    ];
  };
}
