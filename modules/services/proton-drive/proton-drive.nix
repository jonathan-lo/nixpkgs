{ ... }:
let
  # https://proton.me/download/drive/cli/index.html
  mkProtonDrive = lib: pkgs:
    pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "proton-drive";
        version = "0.8.0";

        src = pkgs.fetchurl {
          url = "https://proton.me/download/drive/cli/${finalAttrs.version}/linux-x64-baseline/proton-drive";
          hash = "sha256-dl/UNOfqU/H0XII0CK0Q39ymAGmIWjtXfEIOJRF3UXU=";
        };

        dontUnpack = true;
        nativeBuildInputs = [ pkgs.makeWrapper ];

        installPhase = ''
          runHook preInstall
          install -Dm755 $src $out/libexec/proton-drive
          makeWrapper ${pkgs.stdenv.cc.bintools.dynamicLinker} $out/bin/proton-drive \
            --add-flags "--library-path ${lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib pkgs.glib pkgs.libsecret ]}" \
            --add-flags "$out/libexec/proton-drive"
          runHook postInstall
        '';

        meta = {
          description = "Command-line client for Proton Drive";
          homepage = "https://proton.me/download/drive/cli/index.html";
          license = lib.licenses.unfreeRedistributable;
          sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
          platforms = [ "x86_64-linux" ];
          mainProgram = "proton-drive";
        };
    });
in
{
  flake.allowedUnfreePackages = [ "proton-drive" ];

  flake.modules.nixos.proton-drive =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = [ (mkProtonDrive lib pkgs) ];
    };

  flake.modules.nixos.proton-drive-backup =
    { config, lib, pkgs, ... }:
    let
      backup = pkgs.writeShellApplication {
        name = "proton-drive-backup";
        runtimeInputs = [ (mkProtonDrive lib pkgs) pkgs.coreutils pkgs.util-linux ];
        text = builtins.readFile ./proton-drive-backup.sh;
      };
    in
    {
      options.services.protonDriveBackup.user = lib.mkOption {
        type = lib.types.str;
        description = "User account running the daily Proton Drive backup.";
      };

      # Run in the user's systemd session so the D-Bus Secret Service used by
      # Proton Drive is available. A missed run is retried when the user logs in.
      config.systemd.user.services.proton-drive-backup = {
        unitConfig.ConditionUser = config.services.protonDriveBackup.user;
        serviceConfig = {
          Type = "oneshot";
          ExecStart = lib.getExe backup;
        };
      };
      config.systemd.user.timers.proton-drive-backup = {
        wantedBy = [ "timers.target" ];
        unitConfig.ConditionUser = config.services.protonDriveBackup.user;
        timerConfig = {
          OnCalendar = "*-*-* 12:00:00";
          Persistent = true;
        };
      };
    };
}
