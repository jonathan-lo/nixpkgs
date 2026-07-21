# modules/programs/terminal/workmux [nd]/workmux.nix
{ inputs, ... }:
{
  flake.modules.homeManager.workmux =
    { pkgs, ... }:
    {
      # workmux is not in nixpkgs; take it from its own flake, which also ships
      # bash/zsh/fish completions with the package.
      home.packages = [ inputs.workmux.packages.${pkgs.stdenv.hostPlatform.system}.default ];

      xdg.configFile."workmux/config.yaml".text = ''
        merge_strategy: rebase
        agent: claude
        panes:
          - command: <agent>
            focus: true
          - split: horizontal
      '';
    };
}
