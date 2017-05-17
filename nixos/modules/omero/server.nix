#
# TODO
#
{ config, pkgs, lib, ... }:

with lib;
with types;
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
    enabled = config.omero.server.enable;
  in mkIf enabled
  {
    omero.server.create-machine-account = true;
  };

}
