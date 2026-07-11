sel="${1:-}"
[ -z "$sel" ] && exit 0

root="${GH_REPOS_ROOT:-$HOME/code/github}"

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
