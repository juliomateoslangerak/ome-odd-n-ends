#
# OMERO dependency sets.
# This attribute set is the only place where we should keep OMERO deps, so
# to make it easy to change and track them.
#
{ pkgs, pykgs, ... }:  # 17.09                      NOTE (1)

rec {

  # Python env to run OMERO server, web and CLI tools.
  py-runtime =              #                       NOTE (2)
    with pykgs;
    assert zeroc-ice-py.version == pkgs.zeroc_ice.version;
    pyenv [
      django
      gunicorn
      matplotlib
      numpy
      pillow
      tables
      zeroc-ice-py
    ];

  # Packages required to run OMERO server, web and CLI tools.
  runtime = with pkgs; [
    jre             # openjre-8u131b11
    zeroc_ice       # 3.6.3
    mplayer         # 1.3.0                         NOTE (4)
    py-runtime
  ];

  # Base dev env for OMERO components.
  dev = with pkgs; [
    jdk             # openjdk-8u121b13
    zeroc_ice       # 3.6.3
    mplayer         # 1.3.0                         NOTE (4)
    py-runtime
  ];

  # Packages required to build OMERO components with `build.py`.
  build = with pkgs; [
    jdk             # openjdk-8u121b13
    zeroc_ice       # 3.6.3
    (with pykgs; pyenv [
      setuptools    #                               NOTE (3)
    ])
  ];

}
# Notes
# -----
# 1. Version Numbers. The version numbers noted next to each package name
# refer to the packages in NixOS 17.09. But you can obviously pass in a
# `pkgs` argument that points to a different NixOS package set, in which
# case the version numbers could be different. Version numbers for the
# Python packages are noted in `python/default.nix`.
#
# 2. OMERO Python Runtime Deps. I think most of these Python packages above
# are only needed by OMERO.web, so we could split the runtime dependency set
# into two: Web and server deps?
#
# 3. OMERO Python Build Deps. I've managed to run successfully these build
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
# 4. MEncoder. Movie Maker (OMERO.scripts) needs `mencoder` but NixOS doesn't
# package it separately from MPlayer.
#
