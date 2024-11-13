{ config, pkgs, ... }:

{
  environment.variables = {
    EDITOR = "vi";
    REQUESTS_CA_BUNDLE = "/Library/Certificates/allcerts.pem";
    NIX_SSL_CERT_FILE = "/Library/Certificates/allcerts.pem";
    NODE_EXTRA_CA_CERTS = "/Library/Certificates/allcerts.pem";
  };
}
