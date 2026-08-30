{ ... }:
{
  flake.allowedUnfreePackages = [ "destructive-command-guard" ];

  flake.modules.homeManager.ai =
    { lib, pkgs, ... }:
    let
      version = "0.13.9";
      release =
        {
          "aarch64-darwin" = {
            file = "dcg-aarch64-apple-darwin.tar.xz";
            hash = "sha256-LrQUhloUHGuXnsWnIKK3hi5YFF0MQWDaC+Lj+ES3meU=";
          };
          "x86_64-linux" = {
            file = "dcg-x86_64-unknown-linux-musl.tar.xz";
            hash = "sha256-VQXoFLvryark0+yqHO2zdGoqsdOlv2mpIc4kkflid3g=";
          };
        }
        .${pkgs.stdenv.hostPlatform.system};
      dcg = pkgs.stdenv.mkDerivation {
        pname = "destructive-command-guard";
        inherit version;

        src = pkgs.fetchurl {
          url = "https://github.com/Dicklesworthstone/destructive_command_guard/releases/download/v${version}/${release.file}";
          hash = release.hash;
        };

        nativeBuildInputs = [ pkgs.xz ];
        dontBuild = true;
        unpackPhase = "tar -xJf $src";
        installPhase = "install -Dm755 dcg $out/bin/dcg";

        meta = {
          description = "Guard against destructive commands from coding agents";
          homepage = "https://github.com/Dicklesworthstone/destructive_command_guard";
          license = lib.licenses.unfreeRedistributable;
          mainProgram = "dcg";
        };
      };
    in
    {
      home.packages = [ dcg ];
    };
}
