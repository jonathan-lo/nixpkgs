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
      cfg = config.settings.ghRepos;
      orgsBash = lib.concatMapStringsSep " " lib.escapeShellArg cfg.orgs;
    in
    {
      options.settings.ghRepos.orgs = lib.mkOption {
        description = ''
          GitHub orgs that `gh-repos` lists repositories from. List options
          concatenate across modules, so the private submodule contributes the
          actual org names without them appearing in the public repo.
        '';
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "kubernetes" ];
      };

      config.home.packages = [
        (pkgs.writeShellApplication {
          name = "gh-repos";
          runtimeInputs = with pkgs; [
            gh
            coreutils
            findutils
          ];
          text = ''
            # List every repo (owner/name) across the configured GitHub orgs,
            # excluding archived repos and forks.
            # Result is cached at ~/.repos and refetched when older than 24h.
            #
            # Usage: gh-repos [--refresh] [ORG...]
            #   --refresh    force a refetch, ignoring the cache
            #   ORG...       override the default orgs for this run

            cache="''${REPOS_CACHE:-$HOME/.repos}"
            max_age_min=1440
            force=false
            default_orgs=(${orgsBash})
            orgs=()

            for arg in "$@"; do
              case "$arg" in
                -f | --refresh) force=true ;;
                -h | --help)
                  sed -n '2,6p' "$0" 2>/dev/null || true
                  exit 0
                  ;;
                -*)
                  echo "gh-repos: unknown option: $arg" >&2
                  exit 1
                  ;;
                *) orgs+=("$arg") ;;
              esac
            done

            if [ ''${#orgs[@]} -eq 0 ]; then
              orgs=("''${default_orgs[@]}")
            fi

            if ! $force && [ -f "$cache" ] && [ -z "$(find "$cache" -mmin +"$max_age_min")" ]; then
              cat "$cache"
              exit 0
            fi

            tmp="$(mktemp)"
            trap 'rm -f "$tmp"' EXIT
            for org in "''${orgs[@]}"; do
              gh repo list "$org" --limit 1000 --no-archived --source \
                --json nameWithOwner --jq '.[].nameWithOwner'
            done | sort -u >"$tmp"

            mv "$tmp" "$cache"
            cat "$cache"
          '';
        })
      ];
    };
}
