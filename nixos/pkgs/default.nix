#
# Puts together all our custom packages.
#
{ pkgs, ... }:

with pkgs;

rec {

  zeroc-ice-py = callPackage ./zeroc-ice.python.nix {
    buildPythonPackage = python27Packages.buildPythonPackage;
  };

  omero = callPackage ./omero { inherit zeroc-ice-py; };

}
