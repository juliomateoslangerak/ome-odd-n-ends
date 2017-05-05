#
# Puts together all our custom packages.
#
{ pkgs, ... }:

with pkgs;

rec {

  pykgs = callPackage ./python {};
  omero = callPackage ./omero { inherit pykgs; };

}
