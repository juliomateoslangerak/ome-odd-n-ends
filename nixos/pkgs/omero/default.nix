{ pkgs, pykgs, ... }:

with pkgs;
rec {

  packages = callPackage ./pkgs.nix { inherit pykgs; };
  deps = callPackage ./deps.nix { omero-pkgs = packages; };

}
