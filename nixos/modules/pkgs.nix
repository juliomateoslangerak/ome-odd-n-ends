#
# Convenience module to make our own packages available through a config
# option.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{
  options = {
    ext.pkgs = mkOption {
      type = attrs;
      default = import ../pkgs { inherit pkgs lib; };
      description = ''

      '';
    };
  };
}
# TODO using this module both in homer-container and db:
#
#     with config.ext.pkgs;
#
# causes infinite recursion, figure out why!
