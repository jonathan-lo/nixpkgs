# Wrapper around `workmux add` that prefixes the tmux session (target) name with
# the root repository name, i.e. <root-repo>-<worktree>. Invoke from within a
# repo or one of its linked worktrees: --git-common-dir resolves to the main
# repo's .git in both cases, so the prefix stays stable no matter where you run
# it from. Extra args are forwarded to `workmux add`.
set -euo pipefail

name="$1"
shift

repo="$(basename "$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")")"

exec workmux add "$name" --target-name "${repo}-${name}" "$@"
