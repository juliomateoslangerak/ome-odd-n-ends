#
# Creates the OMERO server account if the OMERO server module is enabled.
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
        The OMERO server user account. By default this is an unprivileged
        user with no login nor home. Username and group are both set to
        `omero`.
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
