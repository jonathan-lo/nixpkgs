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
          cleanup = "zap"; # move this back to zap once lima situation is sorted.
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
