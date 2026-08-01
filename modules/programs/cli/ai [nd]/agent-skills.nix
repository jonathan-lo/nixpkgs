{ ... }:
{
  # Links skill directories from the Nix store into the skill directories of the
  # agent harnesses. Skills are plain `<name>/SKILL.md` trees and the format is
  # shared across harnesses, so a single source can target more than one of them.
  #
  # This file only declares the plumbing; the skills themselves are contributed by the
  # tool files that build them (speckit.nix, plannotator.nix), which set
  # `settings.agentSkills.sources`. All of them merge into the `ai` module, so the
  # options are always declared alongside the definitions that use them.
  flake.modules.homeManager.ai =
    {
      config,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.settings.agentSkills;

      resolveTarget =
        sourceName: harness:
        cfg.harnesses.${harness}
          or (throw "settings.agentSkills.sources.${sourceName}: unknown harness ${harness}; known harnesses: ${concatStringsSep ", " (attrNames cfg.harnesses)}");

      # Skills linked by a previous generation are matched by `globPrefix` and dropped
      # first, so ones that upstream renamed or removed do not linger. Only symlinks are
      # removed: a harness' skill directory also holds real directories installed by
      # other tools, and those are none of our business.
      linkSkills =
        sourceName: source:
        hm.dag.entryAfter [ "writeBoundary" ] ''
          set -euo pipefail

          src=${escapeShellArg "${source.src}"}

          for skillsDir in ${
            concatMapStringsSep " " (harness: escapeShellArg (resolveTarget sourceName harness)) source.targets
          }; do
            $DRY_RUN_CMD mkdir -p "$skillsDir"

            for existing in "$skillsDir"/${source.globPrefix}*; do
              if [ -L "$existing" ]; then
                $DRY_RUN_CMD rm -f "$existing"
              fi
            done

            for skill in "$src"/*; do
              $DRY_RUN_CMD ln -sfn "$skill" "$skillsDir/$(basename "$skill")"
            done
          done
        '';
    in
    {
      options.settings.agentSkills = {
        harnesses = mkOption {
          description = "Skill directory of each agent harness, keyed by harness name.";
          type = types.attrsOf types.str;
          default = {
            claude = "${config.home.homeDirectory}/.claude/skills";
            pi = "${config.home.homeDirectory}/.pi/agent/skills";
          };
        };

        sources = mkOption {
          description = "Skill trees to link into the harnesses that should see them.";
          default = { };
          type = types.attrsOf (
            types.submodule {
              options = {
                src = mkOption {
                  description = "Directory holding one subdirectory per skill.";
                  type = types.path;
                };
                globPrefix = mkOption {
                  description = ''
                    Shared prefix of this source's skill names. Used to reclaim the links of
                    a previous generation, so it must not match skills from another source.
                  '';
                  type = types.str;
                  example = "speckit-";
                };
                targets = mkOption {
                  description = "Harnesses to link these skills into.";
                  type = types.listOf types.str;
                  default = [ "claude" ];
                };
              };
            }
          );
        };
      };

      config.home.activation = mapAttrs' (
        name: source: nameValuePair "link${toSentenceCase name}Skills" (linkSkills name source)
      ) cfg.sources;
    };
}
