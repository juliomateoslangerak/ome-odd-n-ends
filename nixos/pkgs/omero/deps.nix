#
# OMERO dependency sets.
# This attribute set is the only place where we should keep OMERO deps, so
# to make it easy to change and track them.
#
{ pkgs, zeroc-ice-py, ... }:  # 17.09         NOTE (1)

rec {

  # Python env to run OMERO server, web and CLI tools.
  # NOTE (2) (3)
  py-runtime = pkgs.python27.withPackages  # Python 2.7.13
    (ps: with ps; [
      django        # 1.10.7
      gunicorn      # 19.3.0
      matplotlib    # 2.0.0
      numpy         # 1.11.3
      pillow        # 3.4.2  TODO OMERO only supports versions < 3.4!!!
      tables        # 3.2.2
      zeroc-ice-py  # 3.6.3
    ]);
/*
  pillow = pkgs.python27.withPackages .... NOTE (5)
https://github.com/NixOS/nixpkgs/blob/dc7dc77cde12719a6949d7231839a42c4e2b9126/pkgs/top-level/python-packages.nix#L18993
[11:09] <sphalerite> Probably use an override
[11:10] <sphalerite> python.withPackages (ps: [(pillow.overrideAttrs (o: {src = ...; version = "yourVersion"})])
*/

  # Packages required to run OMERO server, web and CLI tools.
  runtime = with pkgs; [
    jre             # openjre-8u131b11
    zeroc_ice       # 3.6.3
    mplayer         # 1.3.0       NOTE (6)
    py-runtime
  ];

  # Base dev env for OMERO components.
  dev = with pkgs; [
    jdk             # openjdk-8u121b13
    zeroc_ice       # 3.6.3
    mplayer         # 1.3.0       NOTE (6)
    py-runtime
  ];

  # Packages required to build OMERO components with `build.py`.
  build = with pkgs; [
    jdk             # openjdk-8u121b13
    zeroc_ice       # 3.6.3
    (python27.withPackages (ps: with ps;  # Python 2.7.13
    [
      setuptools    # 30.2.0      NOTE (4)
    ]))
  ];

}
# Notes
# -----
# 1. Version Numbers. The version numbers noted next to each package name
# refer to the packages in NixOS 17.09. But you can obviously pass in a
# `pkgs` argument that points to a different NixOS package set, in which
# case the version numbers could be different.
#
# 2. Python. The `python27.withPackages` function creates a derivation that
# bundles the packages you list in the argument function with the base Python
# runtime, so that the interpreter can find those packages. Read about it in
# the Nixpkgs manual.
#
# 3. OMERO Python Runtime Deps. I think most of these Python packages above
# are only needed by OMERO.web, so we could split the runtime dependency set
# into two: Web and server deps?
#
# 4. OMERO Python Build Deps. I've managed to run successfully these build
# tasks
#
#     python build.py
#     python build.py release-clients
#     python build.py clean
#
# with just `setuptools` without all the other Python packages mentioned
# in the OMERO docs:
# - http://www.openmicroscopy.org/site/support/omero5.3/developers/installation.html#building-omero
# Probably most of those packages are actually only runtime but not build
# deps? Anyhoo, other build tasks may require additional packages...
#
# 5. Pillow. NixOS 17.03 ships with Pillow 3.4.2 but OMERO only supports
# versions < 3.4!!!
#
# 6. MEncoder. Movie Maker (OMERO.scripts) needs `mencoder` but NixOS doesn't
# package it separately from MPlayer.
#
