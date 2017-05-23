#
# Enables and configures Ngnix as a front-end for OMERO.web if the OMERO.web
# module is enabled.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
with import ../../pkgs { inherit pkgs lib; };  # TODO move outta here!
{

  config = let
    enabled = config.omero.web.enable;
    omero-pkg = omero.packages.server;
    install-dir = toString config.omero.server.install.dir;
    omero-prefix = "${install-dir}/${omero-pkg.name}";
    # TODO duplicated in server module. also path depends on where omero.server
    # package decides to extract zip. refactor to avoid nasty hidden code deps.
    vhost = "omeroweb";
  in mkIf enabled
  {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;  # sets: sendfile on;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "0";
      appendHttpConfig = ''
        send_timeout 60s;

        upstream ${vhost} {
          server 127.0.0.1:4080 fail_timeout=0;
        }
      '';

      virtualHosts.omeroweb = {
        serverName = "$hostname";
        extraConfig = ''
          sendfile on;
          client_max_body_size 0;
        '';
        locations = {
          "@maintenance" = {
            root = "${omero-prefix}/etc/templates/error";
            tryFiles = "$uri /maintainance.html =502";
          };
          "/static" = {
            alias = "${omero-prefix}/lib/python/omeroweb/static";
          };
          "@proxy_to_app" = {
            proxyPass = "http://${vhost}";
            extraConfig = ''
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header Host $http_host;
              proxy_redirect off;
              proxy_buffering off;
            '';
          };
          "/" = {
            tryFiles = "$uri @proxy_to_app";
            extraConfig = ''
              error_page 502 @maintenance;
            '';
           };
        };
      };
    };
  };
}
