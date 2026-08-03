{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "google-chrome" ];

  flake.modules.homeManager.browsers =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # firefox-devedition pinned via inputs.nixpkgs-firefox-devedition — see
      # the colocated flake-parts.nix for why.
      firefoxPinned = import inputs.nixpkgs-firefox-devedition {
        inherit (pkgs.stdenv.hostPlatform) system;
      };

      # macOS `open <url>` never delivers the URL to the Nix-built Firefox. The
      # .app's executable is a wrapper script that execs the real binary, so
      # LaunchServices addresses the GURL Apple Event to a bundle identity no
      # running process claims: the browser focuses but the URL is dropped.
      # Passing the URL as argv to the binary is the handoff that does work, so
      # expose it as a launcher and point $BROWSER at it. Backgrounding keeps
      # callers that wait on the command (plannotator does) from blocking until
      # Firefox exits, which would otherwise hang them whenever it was not
      # already running.
      firefox-open = pkgs.writeShellScriptBin "firefox-open" ''
        "${config.programs.firefox.finalPackage}/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox-devedition" "$@" >/dev/null 2>&1 &
      '';

      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    in
    {
      home.packages = [
        pkgs.google-chrome
      ]
      ++ lib.optional isDarwin firefox-open;

      home.sessionVariables = lib.mkIf isDarwin {
        BROWSER = lib.getExe firefox-open;
      };

      programs.firefox = {
        enable = true;
        package = firefoxPinned.firefox-devedition;
        configPath = "${config.xdg.configHome}/mozilla/firefox";
        policies = {
          ExtensionSettings = {
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
            };
          };
        };
      };
    };
}
