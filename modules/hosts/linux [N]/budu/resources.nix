{ ... }:
{
  # Build resource caps for budu: 10 physical cores / 20 threads, 27 GiB RAM.
  #
  # Unconstrained, Nix defaults to max-jobs = 20 (nproc) with cores = 0 (all
  # threads per job) — up to 400 concurrent compilers, which exhausts RAM and
  # livelocks the machine on swap without ever tripping the OOM killer.
  flake.modules.nixos.budu =
    { ... }:
    {
      nix.settings = {
        max-jobs = 4; # was auto (20)
        cores = 5; # was 0 (unlimited); 4 x 5 = 20 threads
      };

      # Builds are forked children of the daemon (use-cgroups = false), so they
      # share its cgroup. MemoryHigh throttles and reclaims rather than killing,
      # so a heavy build slows down instead of freezing the desktop.
      systemd.services.nix-daemon.serviceConfig.MemoryHigh = "16G";
    };
}
