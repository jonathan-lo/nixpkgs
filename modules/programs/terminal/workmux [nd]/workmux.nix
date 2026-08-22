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
        agent: cc-concise
        mode: session
        agents:
          cc-concise:
            type: claude
            command: claude
            args:
            - --model
            - claude-opus-4-8
            - --append-system-prompt
            - 'You are a concise software engineering assistant. Write tight, professional code without conversational filler or unsolicited explanations.'
        post_create:
        - '[ -f .envrc ] && direnv allow || true'
        files:
          symlink:
          - .envrc
          - .scratch
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
