# Global, restart-proof inventory of every workmux worktree, across every repo.
#
# `workmux list`/`status`/`resurrect` are all repo-scoped -- they run
# `git worktree list` in $PWD and hard-error outside a repo -- and workmux keeps
# no global registry, so this globs the default `worktree_dir` layout instead:
# <project>__worktrees/<handle>. Reading only the filesystem is what makes the
# list survive a tmux or machine restart. (`workmux list` would also be the
# wrong filter: it reports every git worktree of a repo, including stray
# .claude/worktrees/* ones, and costs ~450ms per repo.)
#
# Open/closed comes from the tmux session name workmux records in the main
# repo's git config as `workmux.worktree.<handle>.target-session` -- shared by
# every linked worktree, and cleaned up by `workmux remove`. That reproduces
# `workmux list --json`'s `is_open` exactly, and unlike matching on pane cwd it
# does not mistake a plain `sesh` session that happens to sit in a worktree
# directory for a workmux target. Live session names carry a per-language
# nerdfont icon prefix, hence the suffix match rather than equality.
#
# Emits three tab-separated fields, open rows first:
#   <display> <TAB> <live session name, empty when closed> <TAB> <worktree path>
# config/05-sesh.conf displays field 1 (--with-nth) and returns field 3
# (--accept-nth); field 2 exists so sesh-default-list can drop the sessions it
# would otherwise list a second time via `sesh list -t`.
#
# Usage: workmux-worktrees [--open]
#   --open   only worktrees whose tmux target is currently alive

# No match expands to nothing. dotglob stays off, which excludes .workmux_trash_*.
shopt -s nullglob

only_open=false
[ "${1:-}" = "--open" ] && only_open=true

root="${GH_REPOS_ROOT:-$HOME/code/github}"
live="$(tmux list-sessions -F '#{session_name}' 2>/dev/null || true)"

open_rows=()
closed_rows=()

# The trailing / restricts both globs to directories.
for dir in "$root"/*/*__worktrees/*/ "$HOME"/.config/*__worktrees/*/; do
  worktree="${dir%/}"
  handle="${worktree##*/}"
  project="${worktree%__worktrees/*}"
  repo="${project##*/}"

  target="$(git -C "$project" config --get "workmux.worktree.$handle.target-session" 2>/dev/null || true)"

  session=""
  if [ -n "$target" ]; then
    while IFS= read -r name; do
      if [ "$name" = "$target" ] || [ "$name" != "${name%" $target"}" ]; then
        session="$name"
        break
      fi
    done <<<"$live"
  fi

  if [ -n "$session" ]; then
    open_rows+=("● $repo/$handle"$'\t'"$session"$'\t'"$worktree")
  else
    closed_rows+=("○ $repo/$handle"$'\t\t'"$worktree")
  fi
done

[ ${#open_rows[@]} -gt 0 ] && printf '%s\n' "${open_rows[@]}"

if [ "$only_open" = false ] && [ ${#closed_rows[@]} -gt 0 ]; then
  printf '%s\n' "${closed_rows[@]}"
fi

# Explicit: a trailing `[ ... ] && printf` above would otherwise exit 1 under
# `set -o errexit` whenever the array is empty.
exit 0
