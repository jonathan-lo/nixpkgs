{ inputs, ... }:
{
  flake.modules.darwin.nix-darwin = {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.nix-darwin
    ];
  };

  flake.modules.homeManager.nix-darwin = {
    # ensure that both systemPackages and home manager packages are indexed in Spotlight
    targets.darwin.copyApps.enable = true;
    targets.darwin.linkApps.enable = false;

    # workaround for mac updates breaking nix
    modules.shell.zsh = {
      profileExtra = ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh";

      # ensure nix paths take precedence over macOS system paths
      # (path_helper in /etc/zprofile reorders PATH, pushing nix paths to the end)
      initContent = ''
        export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:$PATH"
      '';
    };
  };
}
