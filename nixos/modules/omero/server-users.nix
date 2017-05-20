#
# Creates the OMERO server (machine) account. This module also defines options
# to configure the OMERO root user's password and the OMERO database user.
#
# TODO keeping passwords in a NixOS module is quite lame. In fact, even if
# you were going to make the module's file only readable by root, a regular
# user could still run `nixos-option` to make NixOS spell the beans.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    omero.server.create-machine-account = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to create the OMERO server Unix account on this machine.
      '';
    };
    omero.server.user = mkOption {
      type = attrs;
      default = {
        name = "omero";
        group = "omero";
        isNormalUser = true;  # NOTE (1)
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
    omero.db.user.name = mkOption {
      type = string;
      default = "omero";
      description = ''
        The OMERO database user name. This is the database user that will own
        the OMERO database. Not to be confused with the OMERO server Unix
        account or the machine's root user or the OMERO root user.
      '';
    };
    omero.db.user.password = mkOption {
      type = string;
      default = "";
      description = ''
        The OMERO database user's password.
      '';
    };
  };

  config = let
    enabled = config.omero.server.create-machine-account;
    omero = config.omero.server.user;
  in mkIf enabled
  {
    users.users."${omero.name}" = omero;
    users.groups."${omero.group}".name = omero.group;
  };

}
# Notes
# -----
# 1. Server User. I've tried running OMERO without a home, but it didn't work.
# Until I find out what else OMERO assumes about its Unix user, I'm going to
# use a regular account to run the server, with a home and a shell. But I'm
# leaving the password out so you can't login with this username which makes
# a bit more secure as a server account.
#
