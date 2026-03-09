{ inputs, ... }:
{
  flake.modules.nixos.budu =
    { pkgs, ... }:
    {
      imports =
        with inputs.self.modules.nixos;
        [
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
        ];

      # Bootloader
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      networking.hostName = "budu";
      networking.networkmanager.enable = true;
      # for vpn compat
      networking.firewall.checkReversePath = false;

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

      # Disable power button
      services.logind.settings = {
        Login = {
          HandlePowerKey = "ignore";
        };
      };

      environment.systemPackages = with pkgs; [
        libreoffice
        protonvpn-gui
        unixtools.ifconfig
      ];

      system.stateVersion = "25.11";
    };
}
