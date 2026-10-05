set -euo pipefail
umask 077

source_dir="$HOME/Documents"
state_dir="$HOME/.local/state/proton-drive-backup"
mkdir -p -- "$state_dir"
chmod 700 -- "$state_dir"
exec >>"$state_dir/backup.log" 2>&1

log() { printf '%s %s\n' "$(date -Is)" "$*"; }
on_exit() {
  local status=$?
  if (( status == 0 )); then
    log 'Backup succeeded'
  else
    log "Backup failed (exit $status)"
  fi
}
trap on_exit EXIT

# Keep a slow upload from overlapping the next scheduled run.
exec 9>"$state_dir/lock"
if ! flock -n 9; then
  log 'Another backup is already running'
  exit 1
fi

if [[ ! -d "$source_dir" || ! -r "$source_dir" ]]; then
  log "Source is missing or unreadable: $source_dir"
  exit 1
fi

# Cron does not inherit the graphical session's D-Bus address. Proton Drive
# retrieves its saved login from the user's Secret Service over this bus.
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export DBUS_SESSION_BUS_ADDRESS="${DBUS_SESSION_BUS_ADDRESS:-unix:path=$XDG_RUNTIME_DIR/bus}"
if [[ ! -S "$XDG_RUNTIME_DIR/bus" ]]; then
  log "User D-Bus socket unavailable: $XDG_RUNTIME_DIR/bus"
  exit 1
fi

host=$(uname -n)
user=$(id -un)
parent='/my-files'
log "Backing up $source_dir to $parent/backups/$host/$user/Documents"

# Check the root first so authentication failures do not look like missing folders.
proton-drive filesystem info "$parent" >/dev/null
for folder in backups "$host" "$user"; do
  path="$parent/$folder"
  if ! proton-drive filesystem info "$path" >/dev/null 2>&1; then
    proton-drive filesystem create-folder "$parent" "$folder"
  fi
  parent="$path"
done

# Uploading the directory creates/merges Documents under the parent. No remote
# deletions: files removed locally remain available for recovery.
proton-drive filesystem upload -f create-new-revision -d merge "$source_dir" "$parent"
