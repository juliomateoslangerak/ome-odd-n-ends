{ pkgs, pykgs, ... }:

with pkgs;

let
  wrap-utils = import ./wrap-utils.nix { inherit pkgs; };
in rec {

  packages = (callPackage ./pkgs.nix {
    inherit wrap-utils pykgs;
    omero-runtime-deps = deps.runtime;
    })
  // {
    db.bootstrap = callPackage ./db-bootstrap.nix {
      inherit wrap-utils;
      postgres = packages.postgres;
      omero-server = packages.server;
      pyenv = pykgs.pyenv;
    };
  };
  deps = callPackage ./deps.nix { omero-pkgs = packages; };

}
