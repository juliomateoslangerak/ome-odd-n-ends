#
# OMERO 5.3 package for NixOS 17.03.
# This package installs a wrapper script that will unzip the OMERO
# server bundle on its first run and call `omero` on each subsequent
# run. The server bundle is unzipped into the specified `omero-root`
# directory and permissions are changed recursively on its contents
# to make them owned by the specified `omero-user` and `omero-group`.
#
# NOTE (1)
#
{ pkgs,
  omero-runtime-deps,
  omero-root ? "/var/lib",  # there's no /opt by default in NixOS
  omero-user ? "omero",
  omero-group ? "omero"
}:

with pkgs;
with lib;

let
  path = concatStrings
         (intersperse ":"
         (map (p: "${p}/bin") omero-runtime-deps));

  omero-wrapper = name: src:
    writeScript "omero-wrapper" ''
      #!${bash}/bin/bash -e

      if [ -d '${omero-root}/${name}' ];
      then
        PATH=${path}:$PATH
        export PATH
        exec '${omero-root}/${name}/bin/omero' "$@"
      else
        echo Setting up OMERO...

        cd '${omero-root}'
        ${unzip}/bin/unzip '${src}'
        chown -R ${omero-user}:${omero-group} '${name}'

        echo ...done! Rerun the omero command now.
      fi
    '';
in
stdenv.mkDerivation rec {

  name = "OMERO.server-${version}";
  release = "5.3.1";
  version = "${release}-ice36-b61";
  meta = {
    homepage = "https://www.openmicroscopy.org/";
    description = ''
      OMERO.server is server software for visualization, management and
      analysis of biological microscope images.
    '';
    license = licenses.gpl2;
  };

  src = fetchurl {
    url = "http://downloads.openmicroscopy.org/omero/" +
          "${release}/artifacts/${name}.zip";
    sha256 = "116ba1ab63b098577ef8c8141a4eb6254f888f43b53304b096a02e42ea8101c0";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${omero-wrapper name src} $out/bin/omero
  '';

}
# Notes
# -----
# 1. Running `omero`. Why not just unzip the OMERO.server bundle in the Nix
# store, like any other package? The problem is that `omero` will only run
# if the whole release zip file is unzipped in a directory with read and
# write access. But the whole Nix store is read-only. I should figure out a
# way to tell `omero` to use different data directories so that we could have
# a proper Nix package. But for the moment, the best I could do is to let
# the user decide where to unpack the server bundle and make sure the `omero`
# command ends up in the PATH through the wrapper script.
#
