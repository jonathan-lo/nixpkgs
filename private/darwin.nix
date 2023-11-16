{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      DOCKER_HOST = "unix://$HOME/.docker/docker.sock";
      REQUESTS_CA_BUNDLE = "/Library/Certificates/allcerts.pem";
      NIX_SSL_CERT_FILE = "/Library/Certificates/allcerts.pem";
    };
  };
}
