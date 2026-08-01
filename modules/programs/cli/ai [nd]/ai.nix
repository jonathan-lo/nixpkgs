{ inputs, ... }:
{
  flake.allowedUnfreePackages = [ "claude-code" ];

  flake.modules.darwin.ai =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.unstable.cmux ];
    };

  flake.modules.homeManager.ai =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      nixpkgsDir = "${config.home.homeDirectory}/.config/nixpkgs";
      publicSettings = "${nixpkgsDir}/modules/programs/cli/ai [nd]/claude/settings.public.json";
      privateSettings = "${nixpkgsDir}/modules/private/claude/settings.private.json";
      liveSettings = "${config.home.homeDirectory}/.claude/settings.json";
      lastRendered = "${config.home.homeDirectory}/.cache/nixpkgs/claude-settings.last.json";

      specKit = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.spec-kit;

      # The Claude integration of spec-kit ships as skills (.claude/skills/speckit-*).
      # `specify init` scaffolds them offline from assets bundled in the pinned CLI, so
      # the generated skills always match the packaged spec-kit version. Bumping the
      # llm-agents input (via `just update`) regenerates them on the next `just apply` —
      # no static copies to rot.
      speckitSkills = pkgs.runCommand "speckit-claude-skills" { nativeBuildInputs = [ specKit ]; } ''
        export HOME="$TMPDIR/home"
        mkdir -p "$HOME" proj
        cd proj
        specify init --here --integration claude --script sh --ignore-agent-tools --force
        mkdir -p "$out"
        cp -R .claude/skills/. "$out/"
      '';

      plannotator = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.plannotator;

      # Plannotator's slash commands ship as skills in its repo, normally installed by the
      # upstream curl installer; the Nix package carries only the binary. Taking them from
      # the package's own source keeps the skills in lockstep with the packaged CLI, and
      # copying them out drops the 40M+ repo checkout from the generation's closure.
      plannotatorSkills = pkgs.runCommand "plannotator-claude-skills" { } ''
        mkdir -p "$out"
        cp -R ${plannotator.src}/apps/skills/core/. "$out/"
      '';

      claudeSkillsDir = "${config.home.homeDirectory}/.claude/skills";

      # Symlinks every skill in `src` into ~/.claude/skills. Skills linked by a previous
      # generation are matched by `globPrefix` and dropped first, so ones that upstream
      # renamed or removed do not linger.
      linkSkills =
        { src, globPrefix }:
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          set -euo pipefail

          skillsDir=${lib.escapeShellArg claudeSkillsDir}
          src=${lib.escapeShellArg "${src}"}

          $DRY_RUN_CMD mkdir -p "$skillsDir"

          for existing in "$skillsDir"/${globPrefix}*; do
            if [ -L "$existing" ]; then
              $DRY_RUN_CMD rm -f "$existing"
            fi
          done

          for skill in "$src"/*; do
            $DRY_RUN_CMD ln -sfn "$skill" "$skillsDir/$(basename "$skill")"
          done
        '';
    in
    {
      home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        # harnesses
        claude-code
        # codex
        pi

        spec-kit

        # usage
        ccusage

        # coordination
        agent-deck

        # review
        plannotator
      ];

      home.activation.mergeClaudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        set -euo pipefail

        publicSrc=${lib.escapeShellArg publicSettings}
        privateSrc=${lib.escapeShellArg privateSettings}
        liveFile=${lib.escapeShellArg liveSettings}
        lastRendered=${lib.escapeShellArg lastRendered}

        $DRY_RUN_CMD mkdir -p "$(dirname "$liveFile")" "$(dirname "$lastRendered")"

        if [ -f "$privateSrc" ]; then
          merged=$(${pkgs.jq}/bin/jq -s '
            (map(.permissions.allow // []) | add | unique) as $allow
            | (.[0] * .[1])
            | .permissions.allow = $allow
          ' "$publicSrc" "$privateSrc")
        else
          echo "claude-settings: private submodule not checked out; using public-only settings" >&2
          merged=$(${pkgs.jq}/bin/jq '.' "$publicSrc")
        fi

        if [ -f "$liveFile" ] && [ -f "$lastRendered" ]; then
          if ! ${pkgs.diffutils}/bin/diff -q "$liveFile" "$lastRendered" >/dev/null 2>&1; then
            echo "claude-settings: ~/.claude/settings.json drifted from the last-rendered version." >&2
            echo "  inspect: diff $lastRendered $liveFile" >&2
            echo "  copy any wanted changes into settings.public.json or settings.private.json before re-applying." >&2
          fi
        fi

        printf '%s\n' "$merged" | $DRY_RUN_CMD tee "$liveFile" "$lastRendered" >/dev/null
      '';

      home.activation.linkSpeckitSkills = linkSkills {
        src = speckitSkills;
        globPrefix = "speckit-";
      };

      home.activation.linkPlannotatorSkills = linkSkills {
        src = plannotatorSkills;
        globPrefix = "plannotator-";
      };
    };
}
