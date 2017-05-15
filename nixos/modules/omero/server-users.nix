#
# Creates the OMERO server (machine) account if the OMERO server module is
# enabled. This module also defines options to configure the OMERO root
# user's password and the OMERO database user.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    omero.server.user = mkOption {
      type = attrs;
      default = {
        name = "omero";
        group = "omero";
        description = "OMERO server user";
      };
      description = ''
        The OMERO server Unix account on this machine. By default this is an
        unprivileged user with no login nor home. Username and group are both
        set to `omero`.
      '';
    };
    omero.users.root.password = mkOption {
      type = string;
      default = "";
      description = ''
        The password for the OMERO server root user. The OMERO root user is
        the built-in admin user in OMERO, i.e. a "special experimenter" within
        the OMERO database. Not to be confused with the OMERO server Unix
        account or the machine's root user.
      '';
    };
    omero.db.user = mkOption {
      type = attrs;
      default = {
        name = "omero";
        password = "";
      };
      description = ''
        The OMERO database user's credentials. This is the database user that
        will own the OMERO database. Not to be confused with the OMERO server
        Unix account or the machine's root user or the OMERO root user.
      '';
    };
  };

  config = let
    enabled = config.omero.server.enable;
    omero = config.omero.server.user;
  in mkIf enabled
  {
    users.users."${omero.name}" = omero;
    users.groups."${omero.group}".name = omero.group;
  };

}