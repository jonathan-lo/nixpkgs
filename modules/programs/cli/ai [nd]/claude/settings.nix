{ ... }:
{
  # Renders ~/.claude/settings.json from a public part tracked here and, on hosts that
  # opt in, a private part from the private submodule, keeping a copy of what was
  # rendered so hand-edits made in Claude itself can be spotted instead of being
  # silently overwritten.
  # Merges into the `ai` module.
  flake.modules.homeManager.ai =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.settings.claude;

      nixpkgsDir = "${config.home.homeDirectory}/.config/nixpkgs";
      publicSettings = "${nixpkgsDir}/modules/programs/cli/ai [nd]/claude/settings.public.json";
      privateSettings = "${nixpkgsDir}/modules/private/claude/settings.private.json";
      liveSettings = "${config.home.homeDirectory}/.claude/settings.json";
      lastRendered = "${config.home.homeDirectory}/.cache/nixpkgs/claude-settings.last.json";

      jq = "${pkgs.jq}/bin/jq";

      # The private submodule is checked out on every host, so opting in has to be a
      # host decision rather than a "does the file exist" test — otherwise the work
      # plugins, marketplaces and hooks leak onto personal machines.
      renderMerged =
        if cfg.private then
          ''
            privateSrc=${escapeShellArg privateSettings}

            if [ ! -f "$privateSrc" ]; then
              echo "claude-settings: settings.claude.private is on but modules/private is not checked out" >&2
              exit 1
            fi

            merged=$(${jq} -s '
              (map(.permissions.allow // []) | add | unique) as $allow
              | (.[0] * .[1])
              | .permissions.allow = $allow
            ' "$publicSrc" "$privateSrc")
          ''
        else
          ''
            merged=$(${jq} '.' "$publicSrc")
          '';
    in
    {
      options.settings.claude.private = mkEnableOption ''
        merging the work-only Claude settings (plugins, marketplaces and hooks) from
        modules/private into ~/.claude/settings.json. Off by default so personal hosts
        render public-only settings
      '';

      config.home.activation.mergeClaudeSettings = hm.dag.entryAfter [ "writeBoundary" ] ''
        set -euo pipefail

        publicSrc=${escapeShellArg publicSettings}
        liveFile=${escapeShellArg liveSettings}
        lastRendered=${escapeShellArg lastRendered}

        $DRY_RUN_CMD mkdir -p "$(dirname "$liveFile")" "$(dirname "$lastRendered")"

        ${renderMerged}

        if [ -f "$liveFile" ] && [ -f "$lastRendered" ]; then
          if ! ${pkgs.diffutils}/bin/diff -q "$liveFile" "$lastRendered" >/dev/null 2>&1; then
            echo "claude-settings: ~/.claude/settings.json drifted from the last-rendered version." >&2
            echo "  inspect: diff $lastRendered $liveFile" >&2
            echo "  copy any wanted changes into settings.public.json or settings.private.json before re-applying." >&2
          fi
        fi

        printf '%s\n' "$merged" | $DRY_RUN_CMD tee "$liveFile" "$lastRendered" >/dev/null
      '';
    };
}
