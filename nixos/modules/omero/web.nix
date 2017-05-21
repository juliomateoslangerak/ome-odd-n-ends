#
# TODO
#
{ config, pkgs, lib, ... }:

with lib;
with types;
with import ../../pkgs { inherit pkgs lib; };  # TODO move outta here!
{

  options = {
    omero.web.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables OMERO Web server on this machine.
      '';
    };
    omero.web.server-list = mkOption {
      type = attrs;
      # TODO type should be the one below, except it's not working!
      # Setting this option with e.g.
      #
      #   web.server-list.x = { host = "h1"; port = 1; };
      #   web.server-list.y = { host = "h2"; port = 2; };
      #
      # has no effect. What ends up in the OMERO config is always the content
      # of the default value. WTH is going on?!
      /*
      type = attrsOf (submodule {
        options = {
          host = mkOption {
            type = string;
            description = ''
              Host name where OMERO.server is running.
            '';
          };
          port = mkOption {
            type = int;
            description = ''
              OMERO.sever port number.
            '';
          };
       };
      });
      */
      default = {
        omero = {
          host = "localhost";
          port = 4064;
        };
      };
      description = ''
        OMERO servers that OMERO.web can connect to.
      '';
    };

  };

  config = let
    cfg = config.omero.web;
    omero-pkg = omero.packages.server;
    bin-omero = "${omero-pkg}/bin/omero";
    install-dir = toString config.omero.server.install.dir;
    omero-prefix = "${install-dir}/${omero-pkg.name}";
    server-username = config.omero.server.user.name;
  in mkIf cfg.enable  # TODO why is that enable always stays false?!
  {
    omero.server.install.enable = true;

    systemd.services.omero-web = {
      description = "OMERO.web";

      bindsTo = [ "omero-server-install.service" ];
      after = [ "multi-user.target" "omero-server-install.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ omero-pkg ];

      serviceConfig = {
        Type = "forking";
        User = server-username;    # NOTE (1)

        ExecStart = "${bin-omero} web start";
        ExecReload = "${bin-omero} web restart";
        ExecStop = "${bin-omero} web stop";
        # Restart = ? TODO ask omelings if there's any gotchas

        PIDFile = "${omero-prefix}/var/django.pid";
        WorkingDirectory = "~";    # NOTE (1)
      };
    };
  };
}
# Notes
# -----
# 1. Service account. You need a non-root account to run `omero`. Also `omero`
# expects to be able to write to the user's home or working directory. I think
# the same applies to OMERO.web but haven't actually checked...
#
