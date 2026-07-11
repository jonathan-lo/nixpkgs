session="claude"
cwd="$PWD"
window="$(basename "$cwd")"

if tmux has-session -t "=$session" 2>/dev/null; then
  tmux new-window -t "=$session" -c "$cwd" -n "$window"
else
  tmux new-session -d -s "$session" -c "$cwd" -n "$window"
fi

if [ -n "${TMUX:-}" ]; then
  tmux switch-client -t "=$session"
else
  tmux attach-session -t "=$session"
fi
