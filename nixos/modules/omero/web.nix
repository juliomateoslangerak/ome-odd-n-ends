#
# Installs and runs OMERO.web as a `systemd` service.
#
# TODO deadlocked on very first start in homer container, systemd's logs
# had a weird message of:
#
#  [ERROR] OMERO.web workers (PID 657) - no such process
#
# grep says it comes from:  OmeroPy/src/omero/plugins/web.py
# Anyhoo, after rebooting homer, everything worked fine. WTH is going on?!
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
  in mkIf cfg.enable
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
# the same applies to OMERO.web but haven't actually checked...(TODO check!)
#
