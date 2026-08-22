{ inputs, ... }:
{
  # Merges into the `ai` module; the linking itself lives in agent-skills.nix.
  flake.modules.homeManager.ai =
    { pkgs, ... }:
    let
      mattpocockSkills = pkgs.runCommand "mattpocock-skills" { } ''
        mkdir -p "$out"
        for skill in ${inputs.mattpocock-skills}/skills/engineering/* ${inputs.mattpocock-skills}/skills/productivity/*; do
          if [ -f "$skill/SKILL.md" ]; then
            cp -R "$skill" "$out/mattpocock-$(basename "$skill")"
          fi
        done
      '';
    in
    {
      # The Claude plugin is configured separately in settings.public.json. These
      # links expose the same published skills to pi without installing them twice
      # in Claude's skill directory.
      settings.agentSkills.sources.mattpocock = {
        src = mattpocockSkills;
        globPrefix = "mattpocock-";
        targets = [ "pi" ];
      };
    };
}
