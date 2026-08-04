# Opening view of the `prefix + j` picker (config/05-sesh.conf): workmux
# worktrees with a live tmux target, then the remaining tmux sessions, this
# config, then every repo in the configured GitHub orgs.
#
# Open worktrees are listed by workmux-worktrees *and* by `sesh list -t` (under
# their raw session name, nerdfont icon and all), so the latter is filtered
# against field 2 of the former to keep each worktree to a single row.
#
# The order is deliberate. fzf reads its input as a stream -- fzf-tmux relays it
# through a fifo -- so the first sections paint immediately even on the
# once-a-day run where `gh-repos` has to refetch from the GitHub API.
#
# Both external sections are best-effort: writeShellApplication runs this under
# `set -o errexit`, and a dead tmux server or a logged-out `gh` must degrade the
# list, not empty it.
#
# `gh-repos` is resolved from PATH rather than referenced as a derivation: it is
# built inside flake.modules.homeManager.ghRepos from that module's
# `settings.git.privateOrgs`, so it is not addressable from tmux.nix without
# making tmux fail to evaluate unless ghRepos is imported too. The ctrl-r bind
# in config/05-sesh.conf already calls it the same way.

worktrees="$(workmux-worktrees --open || true)"

if [ -n "$worktrees" ]; then
  printf '%s\n' "$worktrees"
  sesh list -t 2>/dev/null | grep -Fxv -f <(printf '%s\n' "$worktrees" | cut -f2) || true
else
  sesh list -t 2>/dev/null || true
fi

printf '%s\n' "$HOME/.config/nixpkgs"

gh-repos || true
