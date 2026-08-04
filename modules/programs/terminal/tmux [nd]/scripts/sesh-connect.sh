sel="${1:-}"
[ -z "$sel" ] && exit 0

root="${GH_REPOS_ROOT:-$HOME/code/github}"

# A workmux worktree: hand it to `workmux open` rather than `sesh connect`, so
# it comes back with its configured pane layout instead of a bare shell --
# including worktrees that were closed, or that lost their session to a machine
# restart. There is deliberately no "is it already open?" branch: `workmux open`
# switches to an existing target on its own (that is what its --new flag exists
# to override), and testing for a live session at this path would match a plain
# sesh session sitting in the worktree and skip the layout entirely.
#
# The test demands an *absolute*, existing directory. `sesh list -t` prints
# session names such as `attom-integration__worktrees/hx-704`, which match the
# pattern but are names, not paths -- and would resolve as a relative directory
# whenever the invoking pane sits in the repo's parent. `__worktrees/` is
# workmux's default `worktree_dir`, the same assumption workmux-worktrees globs
# on.
#
# `sesh list` and zoxide rows arrive tilde-prefixed, so expand a leading `~/`
# for the test below; `sesh connect` does its own expansion, so $sel itself is
# left alone.
path="${sel/#\~\//$HOME/}"

case "$path" in
  /*__worktrees/*)
    # --git-common-dir resolves to the main repo's .git from inside a linked
    # worktree (the trick workmux-add.sh uses), and doubles as the validity
    # check: if the directory survived but git no longer tracks it as a
    # worktree, this fails and we fall through to `sesh connect` below, which
    # still yields a usable shell.
    if [ -d "$path" ] &&
      common_dir="$(git -C "$path" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"; then
      # `workmux open` needs a repo in cwd to resolve the handle, an attached
      # client to switch into the target, and seconds to cold-start a closed
      # worktree's panes. A throwaway window gives it all three and lets this
      # run-shell job return immediately instead of freezing the client -- the
      # same reasoning as the `workmux add` binding in config/07-workmux.conf.
      # workmux resolves from the tmux server's PATH, not this script's.
      exec tmux new-window -n workmux-open -c "$(dirname "$common_dir")" \
        "workmux open $(printf '%q' "${path##*/}")"
    fi
    ;;
esac

if [ ! -e "$sel" ] && printf '%s' "$sel" | grep -qE '^[^[:space:]/]+/[^[:space:]/]+$'; then
  dir="$root/$sel"
  if [ ! -d "$dir" ]; then
    mkdir -p "$(dirname "$dir")"
    tmux display-popup -w 80% -h 60% -E "gh repo clone $sel $dir"
  fi
  if [ -d "$dir" ]; then
    sel="$dir"
  fi
fi

exec sesh connect "$sel"
