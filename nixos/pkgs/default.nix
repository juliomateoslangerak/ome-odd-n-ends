#
# Puts together all our custom packages so we can bring them all into scope
# with a single import in the root machine config file.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    pkgs = mkOption {
      type = attrsOf package;
      default = {};
      description = ''
        All our custom packages.
      '';
    };
  };

  config = {
    pkgs.omero-server = import ./omero.server-5.3.nix;
  };

}
