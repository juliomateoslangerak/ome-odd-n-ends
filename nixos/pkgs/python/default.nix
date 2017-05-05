#
# Python packages for the latest OMERO release.
# Most of them are overrides of existing Nix Python packages since OMERO
# needs specific versions older than the current ones in Nixpkgs.
#
{ pkgs, ... }:  # 17.09                             NOTE (1)

with pkgs;
let
  pykgs = python27Packages;  # Python 2.7.13
  build-pykg = pykgs.buildPythonPackage;
  with-pkgs = python27.withPackages;              # NOTE (2)
in {

  # Utility to assemble a Python environment with the specified list of
  # packages from our OMERO package set.
  # Usage:
  #
  #     let pykgs = import path/to/this/file.nix;
  #     ...
  #     my-pyenv = with pykgs; pyenv [
  #       # list of packages in our OMERO package set
  #     ];
  #
  pyenv = ps: with-pkgs (xs: ps);
  # NB we discard xs so to only use the packages declared in this file.

  zeroc-ice-py = callPackage ./zeroc-ice-py.nix {  # 3.6.3
    buildPythonPackage = build-pykg;
  };

  pillow = pykgs.pillow.overrideAttrs (oldAttrs: rec {
    name = "Pillow-${version}";
    version = "3.3.3";
    src = fetchurl {
      url = "mirror://pypi/P/Pillow/${name}.tar.gz";
      sha256 = "0xkv0p1d73gz0a1qaasf0ai4262g8f334j07vd60bjrxs2wr3nmj";
    };
  });

  django = pykgs.django;          # 1.10.7
  gunicorn = pykgs.gunicorn;      # 19.3.0
  matplotlib = pykgs.matplotlib;  # 2.0.0
  numpy = pykgs.numpy;            # 1.11.3
  setuptools = pykgs.setuptools;  # 30.2.0
  tables = pykgs.tables;          # 3.2.2

}
# Notes
# -----
# 1. Version Numbers. For packages that we haven't overridden, the version
# numbers noted next to each package name refer to the packages in NixOS
# 17.09. But you can obviously pass in a `pkgs` argument that points to a
# different NixOS package set, in which case the version numbers could be
# different.
#
# 2. Python Env. The `python27.withPackages` function creates a derivation that
# bundles the packages you list in the argument function with the base Python
# runtime, so that the interpreter can find those packages. Read about it in
# the Nixpkgs manual.
