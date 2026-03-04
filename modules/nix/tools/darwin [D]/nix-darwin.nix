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
    };
  };
}
