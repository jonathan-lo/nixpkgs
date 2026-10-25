# Proton Drive CLI credentials in a local kind CronJob

## Finding (2026-10-15)

**Not a simple credential-file mount.** The installed Proton Drive CLI (v0.8.0, packaged in `modules/services/proton-drive/proton-drive.nix`) retrieves its saved session via the host user's D-Bus Secret Service. The backup script (`modules/services/proton-drive/proton-drive-backup.sh`) explicitly sets `DBUS_SESSION_BUS_ADDRESS` to `/run/user/$(id -u)/bus`, and its earlier failed attempt logged `Failed to load session from secrets ... Cannot autolaunch D-Bus without X11 $DISPLAY`. On this host `org.freedesktop.secrets` is currently present on the user bus. `proton-drive auth login --help` describes an interactive browser sign-in; the CLI help does not advertise a credential-file or environment-variable import. This does **not** prove an alternative supported authentication mechanism does not exist; verify with Proton before depending on one.

## Options

1. **Host user timer (currently working):** keep CLI and keyring in the logged-in user session; simplest and least privilege. The latest backup ran successfully on 2026-10-15. A kind CronJob is not necessary just to schedule uploads.
2. **Host Secret Service socket passthrough (technically plausible, not validated):** configure kind `extraMounts` for `/home/jlo/Documents` (read-only), `/run/user/1000/bus`, and possibly other needed runtime sockets, then pod `hostPath` volumes for paths *inside the kind node*. Run CLI under matching numeric UID; set `XDG_RUNTIME_DIR` and `DBUS_SESSION_BUS_ADDRESS`. The desktop user session, unlocked keyring, bus lifetime and authorization must all remain available when the CronJob runs. Mounting a D-Bus socket does **not** mount the credentials; it grants the pod access to the host's live user bus, with significant security exposure. A read-only socket mount does not prevent sending requests. This is fragile across logout/reboot and not recommended as the production solution.
3. **Pod-owned login/keyring:** investigate whether Proton supports a noninteractive headless auth flow and whether the CLI can use an isolated Secret Service with persisted, unlockable storage. `auth login` is browser-driven in the installed version; no unattended unlock path has been established. Do not export or copy the host keyring or put password/session values into manifests, images, logs, or Nix store. A Kubernetes Secret alone does not implement Secret Service.

For a kind pod, files need two mounts: host -> kind node via `extraMounts`, then node -> pod via Kubernetes `hostPath`. This couples the job to one specific local host/node, and `hostPath` access carries security risks. A CronJob would also need `concurrencyPolicy: Forbid` and a tested upload image. The current script hardcodes `$HOME/Documents` and a host-derived remote path, writes its log under `$HOME`, and requires a live D-Bus socket; it cannot be transplanted unchanged into a container.

**Next safe experiment:** with the user present and keyring unlocked, make a *read-only* `proton-drive filesystem info /my-files` call in a disposable pod using socket passthrough. Do not create a recurring CronJob until it succeeds across logout/login and reboot, and the security implications of exposing the host user bus are accepted. No kind cluster was present (`kind get clusters` returned none), so no pod authentication test has been performed.

## Primary sources

- This repo: `modules/services/proton-drive/proton-drive.nix`, `modules/services/proton-drive/proton-drive-backup.sh`; installed CLI `proton-drive auth login --help`; observed user bus and backup log (quoted above without session values).
- kind node `extraMounts`: https://kind.sigs.k8s.io/docs/user/configuration/#extra-mounts
- Kubernetes `hostPath` volume and security warnings: https://kubernetes.io/docs/concepts/storage/volumes/#hostpath
- D-Bus Secret Service protocol: https://specifications.freedesktop.org/secret-service/latest/
- Proton CLI binaries/version listing (currently lists v0.9.0; this repo pins 0.8.0): https://proton.me/download/drive/cli/index.html
