{ inputs, ... }:
{
  flake.modules.nixos.budu =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-minimal
        determinate
        docker
        nixpkgsConfig
        home-manager
        cli
        keyd
        gnome
        pipewire
        printing
        gpu
        steam
        libreoffice
        protonvpn
        powerkey
      ];

      # Bootloader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "budu";
      networking.networkmanager.enable = true;

      time.timeZone = "Australia/Sydney";

      i18n.defaultLocale = "en_AU.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_AU.UTF-8";
        LC_IDENTIFICATION = "en_AU.UTF-8";
        LC_MEASUREMENT = "en_AU.UTF-8";
        LC_MONETARY = "en_AU.UTF-8";
        LC_NAME = "en_AU.UTF-8";
        LC_NUMERIC = "en_AU.UTF-8";
        LC_PAPER = "en_AU.UTF-8";
        LC_TELEPHONE = "en_AU.UTF-8";
        LC_TIME = "en_AU.UTF-8";
      };

      system.stateVersion = "25.11";
    };
}
