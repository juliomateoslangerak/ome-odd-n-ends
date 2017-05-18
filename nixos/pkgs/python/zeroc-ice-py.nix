#
# ZeroC ICE for Python.
#
# This package is the Nixified version of ZeroC's official Python package:
# - https://pypi.python.org/pypi/zeroc-ice/3.6.3
# From the package description:
#  "This package includes the Ice extension for Python, the standard Slice
#  definition files, and the Slice-to-Python compiler. You will need to
#  install a full Ice distribution if you want to use other Ice language
#  mappings, or Ice services such as IceGrid, IceStorm and Glacier2."
#
# Note this package works both with Python 2.7 and 3.5.
#
{ # lib imports
  fetchurl, lib, buildPythonPackage,
  # package dependencies
  mcpp, bzip2, expat, openssl, db5  # NOTE (2)
}:

with lib;

buildPythonPackage rec {

  name = "zeroc-ice-py-${version}";
  version = "3.6.3";
  meta = {
    homepage = "http://www.zeroc.com/ice.html";
    description = "The internet communications engine --- Python bindings";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };

  src = let
    pname = "zeroc-ice";
    file = "${pname}-${version}.tar.gz";
  in
  fetchurl {
    url = "mirror://pypi/${substring 0 1 pname}/${pname}/${file}";
    sha256 = "052d8zwmwxdr53wjpax97bkrls5iydiy73nqz1knsi79axdiak46";
  };

  buildInputs = [ mcpp bzip2 expat openssl db5 ];  # NOTE (2)

}
# Notes
# -----
# 1. NixOS ZeroC ICE Package. There's a `zeroc_ice` package which provides
# the Slice-to-Python compiler (`slice2py`) but doesn't make the ICE Python
# lib available!
#
# 2. Dependencies. Same as `zeroc_ice` cos we have to build the C++ components
# for the Python lib. Note the C++ gets linked statically but in theory you
# could use the shared objects provided by `zeroc_ice`. The docs for the ICE's
# Python package claim you can do that with a `pip` CLI option:
#
#   --install-option="–with-builtin-ice"
#
# but there's no such a thing in their `setup.py`, rather there's a
# `--with-installed-ice` option which I've tried to use to no avail:
#
#   installFlags = [ "--install-option='--with-installed-ice'" ];
#
# (See the Nixpkgs manual for the details.) So static linking it is for the
# time being...
#
# 3. Testing. I've successfully built and run the ICE Python "Hello World" app
# with both Python 2.7 and 3.5. To reproduce, first run `nix-shell` with e.g.
#
#    with import <nixpkgs> {}; with pkgs; with lib;
#    let
#      zeroc-ice-py = callPackage ./zeroc-ice.python.nix {
#      buildPythonPackage = python27Packages.buildPythonPackage;
#    };
#    in (python27.withPackages (ps: [ zeroc-ice-py ])).env
#
# for a Python 2.7 set up. (For 3.5 just replace every occurrence of 27 above
# with 35.) Then build and run the "Hello World" example as explained at:
# - https://doc.zeroc.com/display/Ice36/Writing+an+Ice+Application+with+Python
#
