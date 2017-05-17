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
  };

# omero-bootstrap-db --db-name omero --db-user omero --db-pass abc123
# --server-pass abc123 --pg-username root
# NB needs r/w access to pwd

  config = let
    db = config.omero.db;
    enabled = db.enable;

    db-scripts = omero.packages.db.bootstrap.override {
      db-name = db.name;
      db-user = db.user.name;
      db-pass = db.user.password;
      server-pass = config.omero.users.root.password;
    };
    create-script = "${db-scripts}/sql/create.sql";
    init-script = "${db-scripts}/sql/init.sql";

#    psql = "psql -p ${toString config.services.postgresql.port} -U ${db-user}";
    psql = "psql -p ${toString config.services.postgresql.port} -U root";
    # NixOS Postgres module creates a DB admin role of "root" instead of
    # customary "postgres". So if we exec the script using the "postgres"
    # NixOS user, we should be able to log in as DB admin without specifying
    # a password as long as trust auth is enabled.

# CREATE ROLE "${db-user}" LOGIN PASSWORD '${db-pass}';
# CREATE DATABASE "${db-name}" OWNER "${db-user}" ENCODING 'UTF8';


  in mkIf enabled
  {
    postgres.enable = true;
    omero.server.install.enable = true;
/*
    systemd.services.omero-db-init = {
      description = "One-off OMERO database creation and initialisation.";

      bindsTo = [ "postgresql.service" ];
      after = [ "multi-user.target" "postgresql.service" ];
      # wantedBy = [ "multi-user.target" ]; shouldn't be needed! see manual

      path = [ pkgs.postgresql ];
      script = ''
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo ${create-script}
        echo ${init-script}
        echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        # ${psql} -f ${create-script}
        # ${psql} -d '${db.name}' -f ${init-script}
      '';
      # pwd is written to generated script, piping avoids leaving the script
      # lying around with the password in it.

      serviceConfig = {
        Type = "oneshot";
        # User = "postgres";  # TODO get from config
        # ExecStart = ?;  not needed, because we specified a script, the NixOS
        # systemd module will set ExecStart for us to point to a shell script
        # containing a shebang followed by the content of out script attribute.
      };
    };
*/
  };

}
# Notes
# -----
# 1. OMERO Unix account. You need a non-root account to run `omero db`, so
# reuse the existing OMERO Unix account instead of creating an account just
# to run this service.
#
