#
# Enables Posgres and creates a DBA.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    postgres.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables Posgres and creates a DBA.
      '';
    };
    postgres.dba.name = mkOption {    # NOTE (1)
      type = string;
      default = "dba";
      description = ''
        Username of the Posgres database administrator. We create a regular,
        unprivileged Unix user account having this username and initial
        password of 'abc123'. Then we map this new Unix user to the Postgres
        super user so that it can connect to any database in the local cluster
        using Unix domain sockets or the loopback interface if Postgres TCP/IP
        is enabled. This way you can manage your cluster without having to log
        in as (Unix) root with e.g.

            $ psql -U root

        Note the 'root' user passed to `psql` is the name of the Postgres super
        user in the database, which in NixOS happens to be 'root' instead of
        the customary 'postgres'.
      '';
    };
  };

  config = let
    cfg = config.postgres;
    pwd = "$6$DmW6Owb/Swuzs7$DKca.vHGUP3bTz/G5vae4/egALZVVdsGdkhzISU11ZsFy2jmMVkZtIwTbNzK5cau9AOmb2B4LTd6BxcOKR1oW1";

    postgres-user = config.users.users.postgres;
    pg-su = "root";    # NOTE (1)
  in mkIf cfg.enable
  {
    users.users."${cfg.dba.name}" = {
      name = cfg.dba.name;
      isNormalUser = true;
      hashedPassword = pwd;
    };

    services.postgresql = {
      enable = true;

      identMap = ''
        # Map system users to Postgres database admin users.
        # MAPNAME       SYSTEM-USERNAME         PG-USERNAME
        admin           root                    ${pg-su}
        admin           ${postgres-user.name}   ${pg-su}
        admin           ${cfg.dba.name}         ${pg-su}
      '';
      authentication = ''
        # Allow selected local system users to connect to any database as the
        # Postgres DBA user. These are the Unix users specified in the `admin`
        # identity map. We allow them to connect using both Unix-domain sockets
        # and the TCP/IP loopback interface.
        # TYPE  DATABASE  USER      ADDRESS         METHOD
        local   all       ${pg-su}                  ident map=admin
        host    all       ${pg-su}  127.0.0.1/32    ident map=admin
        host    all       ${pg-su}  ::1/128         ident map=admin
      '';

    };
  };

}
# Notes
# -----
# 1. Postgres Super User. The NixOS Postgres module initialises the Postgres
# database cluster with the command
#
#     initdb -U root
#
# which tells Postgres to create a new cluster and a database super user named
# 'root' (i.e. same user name as the Unix root account's), sort of against
# ancient customs that would have it named 'postgres' instead.
#
