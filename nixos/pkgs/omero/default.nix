{ pkgs, pykgs, ... }:

with pkgs;
rec {

  packages = (callPackage ./pkgs.nix {
    inherit pykgs;
    omero-runtime-deps = deps.runtime;
    })
  // {
    db.bootstrap = callPackage ./db-bootstrap.nix {
      postgres = packages.postgres;
      omero-server = packages.server;
      omero-runtime-deps = deps.dev;
    };
  };
  deps = callPackage ./deps.nix { omero-pkgs = packages; };

}
