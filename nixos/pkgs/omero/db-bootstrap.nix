#
# OMERO 5.3 database bootstrap package for NixOS 17.03.
# IMPORTANT: read NOTE (1) before using!!!
#
{ pkgs,
  postgres,  # our version that goes with OMERO
  omero-server,
  omero-runtime-deps,
  db-user ? "omero",
  db-pass ? "abc123",
  db-name ? "omerodb",
  server-pass ? "abc123"
}:

with pkgs;
with lib;
let
  removeWhiteSpace = replaceStrings [" " "\n" "\r" "\t"] ["" "" "" ""];
  ensureString = x: assert (removeWhiteSpace x) != ""; x;

  # Single quote escaping in Postgres: two single quotes.
  escapePgSqlSingleQuote = replaceStrings ["'"] ["''"];
  # Double quote escaping in Postgres: two double quotes.
  escapePgSqlDoubleQuote = replaceStrings [''"''] [''""''];

  toPgSlqQuotedIdentifier = x: ''"${escapePgSqlDoubleQuote x}"'';
  toPgSqlString = x: "'${escapePgSqlSingleQuote x}'";

  create-script = "create.sql";
  init-script = "init.sql";

  create-script-src = writeText create-script ''
    CREATE ROLE ${toPgSlqQuotedIdentifier (ensureString db-user)}
           LOGIN PASSWORD ${toPgSqlString db-pass};

    CREATE DATABASE ${toPgSlqQuotedIdentifier (ensureString db-name)}
           OWNER ${toPgSlqQuotedIdentifier db-user}
           ENCODING 'UTF8';
  '';

  omero-db-bootstrap = "omero-db-bootstrap";
  omero-db-bootstrap-src = writeScript "omero-db-bootstrap" ''
    #!${bash}/bin/bash -e
    dir="$(dirname -- "$0")";
    echo ">>>>>>>>>>>>>>>: $dir";
    ls $dir
  '';
in
stdenv.mkDerivation rec {

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

  src = omero-server.src;  # NOTE (2)

  buildInputs = [ unzip postgres ] ++ omero-runtime-deps;

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = ''
    ./bin/omero db script  \
                --password '${ensureString server-pass}'   \
                --file ${init-script}
  '';

  installPhase = ''
    INST_DIR=$out/sql
    mkdir -p $INST_DIR

    ln -s ${omero-db-bootstrap-src} $INST_DIR/${omero-db-bootstrap}
    ln -s ${create-script-src} $INST_DIR/${create-script}
    cp ${init-script} $INST_DIR/
  '';

}
# Notes
# -----
# 1. Security. The scripts we generate contain passwords and end up in the
# Nix store which is world-readable! It goes without saying the only use
# you should ever make of this derivation is to set up your own private
# OMERO dev environment.
#
# 2. OMERO.server Package. We can't just add it to the build inputs so that
# `omero` ends up in our PATH. In fact, `omero` will only run if the whole
# release zip file is unzipped in a directory with read and write access. So
# we can't use the store path of the server package as that's read-only. We
# need to unpack the zip here in the build directory (which is writable) and
# run the contained `bin/omero`.
#
