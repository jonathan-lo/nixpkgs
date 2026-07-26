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
        nerdfont: true
        merge_strategy: rebase
        agent: claude
        mode: session
        post_create:
        - direnv allow
        files:
          symlink:
          - .envrc
        windows:
        - name: agent
          panes:
            - command: <agent>
              focus: true
            - split: horizontal
        - name: editor
          panes:
            - command: vi
      '';
    };
}
