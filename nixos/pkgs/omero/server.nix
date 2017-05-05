#
# OMERO 5.3 package for NixOS 17.03.
#
{ stdenv, pkgs, lib, ... }:

with pkgs;

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
    license = lib.licenses.gpl2;
  };

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "http://downloads.openmicroscopy.org/omero/" +
          "${release}/artifacts/${name}.zip";
    sha256 = "116ba1ab63b098577ef8c8141a4eb6254f888f43b53304b096a02e42ea8101c0";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -r * $out/
  '';

}
