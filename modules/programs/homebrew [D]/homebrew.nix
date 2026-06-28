{ inputs, ... }:
{
  flake.modules.darwin.homebrew =
    { config, ... }:
    {
      environment.systemPath = [ "${config.homebrew.prefix}/bin" ];

      home-manager.sharedModules = [
        inputs.self.modules.homeManager.homebrew
      ];

      homebrew = {
        enable = true;
        brews = [
          "JetBrains/utils/kotlin-lsp"
          "node" # install via homebrew so can use npm to install mcps
        ];
        casks = [
          "claude-devtools"
          "ghostty"
          "logseq"
        ];

        extraConfig = ''
          cask_args require_sha: true
        '';

        global = {
          brewfile = true;
        };

        onActivation = {
          autoUpdate = false;
          # Homebrew 5.x removed `brew bundle --force-cleanup`, which nix-darwin still
          # emits for cleanup = "zap" (modules/homebrew.nix), breaking activation. Drive
          # the replacement flags (`--cleanup` implies force, `--zap` selects zap) directly
          # via extraFlags until nix-darwin catches up. Equivalent to cleanup = "zap".
          cleanup = "none";
          extraFlags = [
            "--cleanup"
            "--zap"
          ];
          upgrade = false;
        };

        taps = [
          "JetBrains/utils"
        ];
      };
    };

  flake.modules.homeManager.homebrew =
    { lib, ... }:
    {
      home.sessionPath = lib.mkBefore [
        "/opt/homebrew/bin"
      ];
    };
}
