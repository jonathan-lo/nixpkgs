{ inputs, ... }:
{
  flake.modules.nixos.budu = { pkgs, ... }: {
    imports = with inputs.self.modules.nixos; [
      determinate
      nixpkgsConfig
      home-manager
      cli
      keyd
    ] ++ [
      ./_hardware-configuration.nix
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

    # X11 and GNOME
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.xkb = {
      layout = "au";
      variant = "";
    };

    # Printing
    services.printing.enable = true;

    # Sound with pipewire
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Disable power button
    services.logind.settings = {
      Login = {
        HandlePowerKey = "ignore";
      };
    };

    # Hardware acceleration
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # AMD GPU controller
    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];

    users.users.jlo = {
      isNormalUser = true;
      description = "jonathan";
      extraGroups = [
        "docker"
        "networkmanager"
        "wheel"
      ];
    };

    programs.steam.enable = true;

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      lact
      libreoffice
      protonvpn-gui
      unixtools.ifconfig
    ];

    virtualisation.docker.enable = true;

    system.stateVersion = "25.11";

    home-manager.users.jlo = {
      imports = with inputs.self.modules.homeManager; [
        ai
        aws
        bash
        bat
        bitwarden
        browsers
        btop
        calibre
        cli
        direnv
        docker
        editor
        firefox
        fzf
        gcp
        go
        java
        kubernetes
        node
        ops
        git
        platform
        ripgrep
        theming
        tmux
        zoxide
        zsh
        ghostty
        lazyvim
      ];

      home = {
        stateVersion = "22.05";
        username = "jlo";
      };
    };
  };
}
