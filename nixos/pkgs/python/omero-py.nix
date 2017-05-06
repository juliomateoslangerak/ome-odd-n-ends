#
# OMERO.py 5.3 package for NixOS 17.03.
#
{ pkgs, lib, buildPythonPackage, python, zeroc-ice-py }:

with pkgs;
with lib;

buildPythonPackage rec {

  name = "OMERO.py-${version}";
  release = "5.3.1";
  version = "${release}-ice36-b61";
  meta = {
    homepage = "https://www.openmicroscopy.org/";
    description = "OMERO Python language bindings.";
    license = lib.licenses.gpl2;
  };

  format = "other";                               # NOTE (1)

  buildInputs = [ unzip ];
  propagatedBuildInputs = [ zeroc-ice-py ];

  src = fetchurl {
    url = "http://downloads.openmicroscopy.org/omero/" +
          "${release}/artifacts/${name}.zip";
    sha256 = "1x55pm96p2mfn183cyx905d55hybkb6x71mlrpcyj49grzq7bcbj";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/${python.sitePackages}
    cp -r lib/python/* $out/${python.sitePackages}/
  '';                                             # NOTE (1)

}
# Notes
# -----
# 1. OMERO.py Package. The zip bundle has no `setup.py` in it, so we have
# to do things slightly differently than usual---e.g. with Python wheels.
# A `format` attribute of "other" says we're taking care of the build and
# install phase. Whereas there's nothing to build, we still have to copy
# the sources to the Python lib directory; the Nix Python scripts then
# take care of sym-linking into the Python interpreter derivation whose
# directory is added to the PYTHONPATH. More about it in the Nixpkgs manual.
#
