{ ... }:
{
  # https://proton.me/download/drive/cli/index.html
  flake.allowedUnfreePackages = [ "proton-drive" ];

  flake.modules.nixos.proton-drive =
    { lib, pkgs, ... }:
    let
      proton-drive = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
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
            --add-flags "--library-path ${lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}" \
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
      environment.systemPackages = [ proton-drive ];
    };
}
