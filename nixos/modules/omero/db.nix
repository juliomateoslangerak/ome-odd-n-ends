#
# OMERO database module.
# This module starts Postgres and initialises the OMERO database if needed.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
with import ../../pkgs { inherit pkgs lib; };  # TODO move outta here!
{

  options = {
    omero.db.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Starts Postgres and creates the OMERO database if it's not been
        created yet.
      '';
    };
    omero.db.name = mkOption {
      type = string;
      default = "omerodb";
      description = ''
        The name of the OMERO database.
      '';
    };
    omero.db.host = mkOption {
      type = string;
      default = "localhost";
      description = ''
        Host name of the machine where the OMERO database sits.
      '';
    };
    omero.db.port = mkOption {
      type = int;
      default = config.services.postgresql.port;
      description = ''
        TCP port on which the database server is listening for connections.
      '';
    };
  };

  config = let
    db = config.omero.db;
    enabled = db.enable;

    db-name = db.name;
    db-user = db.user.name;
    db-pass = db.user.password;
    server-pass = config.omero.users.root.password;

    dba-username = config.postgres.dba.name;

  in mkIf enabled
  {
    postgres.enable = true;
    omero.server.install.enable = true;

    systemd.services.omero-db-init = {
      description = "One-off OMERO database creation and initialisation.";

      bindsTo = [ "postgresql.service" "omero-server-install.service" ];
      after = [ "multi-user.target" "postgresql.service"
                "omero-server-install.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [ omero.packages.db.bootstrap ];
      script = ''
        omero-bootstrap-db --pg-username root \
                           --db-name ${escapeShellArg db-name} \
                           --db-user ${escapeShellArg db-user} \
                           --db-pass ${escapeShellArg db-pass} \
                           --server-pass ${escapeShellArg server-pass}
      '';                     # NOTE (1) (2)

      serviceConfig = {       # NOTE (1)
        Type = "oneshot";
        User = dba-username;  # NOTE (3)
        WorkingDirectory = "~";
      };
    };

  };

}
# Notes
# -----
# 1. NixOS systemd scripts. If you use a service script, then you don't have
# to specify a `serviceConfig.ExecStart` because the NixOS systemd module will
# set it to point to the script generated from the `script` attribute. Also
# note the generated script already comes with a shebang, so we don't have to
# add it to the contents of the `script` attribute.
#
# 2. Passwords. TODO! The script gets written with all the passwords in clear
# text to the Nix store which is world readable. The horror! Also as already
# noted in `server-users`, we can't possibly keep passwords in a module. A
# cheap fix is to read those passwords from a user-provided JSON file and pipe
# them into `omero-bootstrap-db` or use an external environment file (see
# EnvironmentFile in `systemd.exec` man page) or a combination of the two.
# A better option would be to implement a more secure mechanism backed by
# password stores, auth services, etc.
#
# 3. Service account. You need a non-root account to run `omero`, so we
# use DBA account created by our `postgres` module. Also `omero` expects
# to be able to write to the user's home or working directory. Specifying
# a regular user makes the user's home the working directory when systemd
# runs the script---see `systemd.exec` man page.
#
