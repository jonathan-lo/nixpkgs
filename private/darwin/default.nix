{ config, pkgs, ... }:

{
  home = {
    sessionVariables = {
      REQUESTS_CA_BUNDLE = "/Library/Certificates/allcerts.pem";
      NIX_SSL_CERT_FILE = "/Library/Certificates/allcerts.pem";
    };
  };
}
