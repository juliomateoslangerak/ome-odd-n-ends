#
# OMERO 5.3 database bootstrap package for NixOS 17.03.
# Installs a `omero-bootstrap-db` command to bootstrap the OMERO database
# as documented in `db-boostrap.py`.
#
{ pkgs,
  postgres,  # our version that goes with OMERO
  omero-server,
  omero-py-runtime
}:

with import ./wrap-utils.nix { inherit pkgs; };

let
  exec-name = "omero-bootstrap-db";
  db-bootstrap-wrapper = src:
    makePgmWrapper {
      name = exec-name;
      runtime-deps = [ postgres omero-server omero-py-runtime];
      pgm = [ "python" src ];
    };
in
pkgs.stdenv.mkDerivation rec {

  name = "OMERO.db-bootstrap-${version}";
  release = omero-server.release;
  version = omero-server.version;
  meta = {
    homepage = omero-server.meta.homepage;
    description = ''
      Database bootstrap scripts for OMERO.server.
    '';
    license = omero-server.meta.license;
  };

  src = ./db-bootstrap.py;

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${db-bootstrap-wrapper src} $out/bin/${exec-name}
  '';

}
