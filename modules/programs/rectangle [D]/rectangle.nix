{ ... }:
{
  flake.modules.darwin.rectangle = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      rectangle
    ];
  };
}
