{ inputs, ... }:
{
  flake.modules.homeManager.gcp = { pkgs, ... }: {
    home.packages = with pkgs; [
      (unstable.google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.cloud-firestore-emulator
        google-cloud-sdk.components.cloud-sql-proxy
        google-cloud-sdk.components.gke-gcloud-auth-plugin
      ])
    ];
  };
}
