#
# Installs and runs OMERO.server as a `systemd` service.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
with import ../../pkgs { inherit pkgs lib; };  # TODO move outta here!
{

  options = {
    omero.server.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables OMERO server on this machine.
      '';
    };
  };

  config = let
    cfg = config.omero.server;
    omero-pkg = omero.packages.server;
    bin-omero = "${omero-pkg}/bin/omero";
    omero-prefix = "${toString cfg.install.dir}/${omero-pkg.name}";
  in mkIf cfg.enable
  {
    omero.server.install.enable = true;

    systemd.services.omero = {
      description = "OMERO.server";

      bindsTo = [ "omero-server-install.service" ];
      after = [ "multi-user.target" "omero-server-install.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ omero-pkg ];

      serviceConfig = {
        Type = "forking";
        User = cfg.user.name;      # NOTE (1)

        ExecStart = "${bin-omero} admin start";
        ExecReload = "${bin-omero} admin restart";
        ExecStop = "${bin-omero} admin stop";
        # Restart = ? TODO ask omelings if there's any gotchas

        PIDFile = "${omero-prefix}/var/master/master.pid";
        WorkingDirectory = "~";    # NOTE (1)
      };
    };
  };
}
# Notes
# -----
# 1. Service account. You need a non-root account to run `omero`. Also `omero`
# expects to be able to write to the user's home or working directory.
#
