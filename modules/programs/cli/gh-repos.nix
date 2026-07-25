{ ... }:
{
  flake.modules.homeManager.ghRepos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      orgsBash = lib.concatMapStringsSep " " lib.escapeShellArg config.settings.git.privateOrgs;
    in
    {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "gh-repos";
          runtimeInputs = with pkgs; [
            gh
            coreutils
            findutils
          ];
          text = builtins.replaceStrings [ "@defaultOrgs@" ] [ orgsBash ] (builtins.readFile ./gh-repos.sh);
        })
      ];
    };
}
