#
# OMERO Marshal package.
# This package is the Nixified version of OME's official Python package:
# - https://pypi.python.org/pypi/omero-marshal/0.5.1
#
# This Nix package works with Python 2.7 but not 2.6. Might work with
# Python 3 too, but I haven't tested it.
#
{ pkgs, lib, buildPythonPackage }:

with pkgs;
with lib;

buildPythonPackage rec {

  name = "omero-marshal-${version}";
  version = "0.5.1";
  meta = {
    homepage = "https://github.com/openmicroscopy/omero-marshal";
    description = ''
      Extensible marshaling code to transform various OMERO objects into
      dictionaries which can then be marshalled using JSON or alternative
      encodings.
    '';
    license = licenses.gpl2;
    platforms = platforms.unix;
  };

  src = let
    pname = "omero_marshal";
    file = "${pname}-${version}.tar.gz";
  in
  fetchurl {
    url = "mirror://pypi/${substring 0 1 pname}/${pname}/${file}";
    sha256 = "14gwxp53r027n9s60vv988yv6sqjmbrjn9q3c2i8dlpqhaa9xjcl";
  };

  # NOTE (2)
  prePatch = ''
    substituteInPlace requirements.txt --replace "importlib>=1.0.1" ""
  '';

  doCheck = false;  # NOTE (3)

}
# Notes
# -----
# 1. OmeroPy Dependency. TODO! The code in omero_marshal depends on the
# OMERO Python bindings:
# - http://www.openmicroscopy.org/site/support/omero5.3/developers/Python.html
# So to use the lib you should set your PYTHONPATH as documented above.
# I should Nixify OmeroPy too though at some point...
#
# 2. importlib. Back-port of Python 3 import functionality but it only works
# with Python 2.6 not with 2.7. For the moment I'm only using Python 2.7, so
# can safely zap the dependency. Anyhoo, the OMERO guys are likely to make it
# conditional, e.g.
#
#     importlib>=1.0.1; python_version=='2.6'
#
# When that happens, get rid of `prePatch` above.
# See:
# - https://pip.pypa.io/en/stable/reference/pip_install/#requirement-specifiers
#
# 3. Tests. Won't run because of the dependency on OmeroPy, see (1).
# Disabling the running of the test suite until I put together a Nix
# package for OmeroPy too.
#
