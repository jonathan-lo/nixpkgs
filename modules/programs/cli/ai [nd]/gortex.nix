{ ... }:
{
  # https://github.com/zzet/gortex
  # Merges into the `ai` module. Upstream's release tarballs are used rather than a source
  # build: nixpkgs doesn't package it, and its ~250 CGO tree-sitter grammars would compile
  # on every host for a release cadence of days. Bump the pin with `just update-gortex`.
  flake.modules.homeManager.ai =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      release = lib.importJSON ./gortex.json;

      platform = pkgs.stdenv.hostPlatform;
      os = if platform.isDarwin then "darwin" else "linux";
      arch = if platform.isAarch64 then "arm64" else "amd64";
      asset = "gortex_${os}_${arch}.tar.gz";

      gortex = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "gortex";
        inherit (release) version;

        src = pkgs.fetchurl {
          url = "https://github.com/zzet/gortex/releases/download/v${finalAttrs.version}/${asset}";
          hash = release.hashes.${asset};
        };

        # The tarball has no top-level directory.
        sourceRoot = ".";

        nativeBuildInputs = [ pkgs.installShellFiles ];

        dontBuild = true;
        # Upstream ships the binaries stripped, and re-stripping the darwin ones would
        # invalidate their code signature.
        dontStrip = true;

        installPhase = ''
          runHook preInstall

          install -Dm755 gortex $out/bin/gortex
          installShellCompletion --cmd gortex \
            --bash <($out/bin/gortex completion bash) \
            --fish <($out/bin/gortex completion fish) \
            --zsh <($out/bin/gortex completion zsh)

          runHook postInstall
        '';

        meta = {
          description = "Code intelligence engine that indexes repositories into a knowledge graph";
          homepage = "https://github.com/zzet/gortex";
          license = lib.licenses.asl20;
          sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
          platforms = [
            "aarch64-darwin"
            "aarch64-linux"
            "x86_64-darwin"
            "x86_64-linux"
          ];
          mainProgram = "gortex";
        };
      });

      # launchd and systemd start the daemon without a login environment, but it runs git,
      # toolchains and language servers from PATH, so it gets the search path a login shell has.
      servicePath = lib.concatStringsSep ":" (
        lib.optionals platform.isLinux [ "/run/wrappers/bin" ]
        ++ [
          "${config.home.profileDirectory}/bin"
          "/run/current-system/sw/bin"
          "/nix/var/nix/profiles/default/bin"
        ]
        ++ config.home.sessionPath
        ++ lib.optionals platform.isDarwin [
          "/usr/local/bin"
          "/usr/bin"
          "/bin"
          "/usr/sbin"
          "/sbin"
        ]
      );

      # The daemon runs under a service manager so that a new binary restarts it: the unit
      # references the store path, and home-manager reloads units whose definition changed.
      # The name matches upstream's `gortex daemon install-service`, which is how gortex
      # recognises the supervisor and routes `daemon stop` / `daemon restart` through it.
      serviceName = "com.zzet.gortex";
      daemonStart = [
        (lib.getExe gortex)
        "daemon"
        "start"
      ];
      # launchd has no log sink of its own, so point it where `gortex daemon logs` reads;
      # under systemd the output goes to the journal instead.
      daemonLog = "${config.home.homeDirectory}/.gortex/cache/daemon.log";
    in
    {
      home.packages = [ gortex ];

      launchd.agents.gortex = lib.mkIf platform.isDarwin {
        enable = true;
        config = {
          Label = serviceName;
          ProgramArguments = daemonStart;
          RunAtLoad = true;
          # Restart on a crash, but let an explicit `gortex daemon stop` stay down.
          KeepAlive.SuccessfulExit = false;
          EnvironmentVariables.PATH = servicePath;
          StandardOutPath = daemonLog;
          StandardErrorPath = daemonLog;
        };
      };

      systemd.user.services.${serviceName} = lib.mkIf platform.isLinux {
        Unit = {
          Description = "Gortex code intelligence daemon";
          Documentation = "https://github.com/zzet/gortex";
        };
        Service = {
          ExecStart = lib.escapeShellArgs daemonStart;
          Environment = ''"PATH=${servicePath}"'';
          Restart = "on-failure";
          RestartSec = 2;
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
}
