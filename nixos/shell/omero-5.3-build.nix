#
# Nix expression to set up an OMERO 5.3 build environment.
# You can only use this environment to build the OMERO components with the
# `build.py` script. If you also need to run OMERO apps as you develop, use
# `omero-5.3.-dev.nix` instead.
# Use with `nix-shell` on NixOS 17.03:
#
#     $ nix-shell omero-5.3-build.nix
#
with import <nixpkgs> {};  # 17.03    NOTE (1)
with import ./util.nix;

let
  shell-name = "omero-5.3-build";
in
runCommand "dummy"
{

  buildInputs = with python27Packages; [
    jdk         # openjdk-8u121b13
    zeroc_ice   # 3.6.3
    python27    # 2.7.13
    setuptools  # 30.2.0              NOTE (2)
  ];

  shellHook = setShellHook { inherit shell-name zeroc_ice; };

} ""
# Notes
# -----
# 1. Nix Package Versions. I've noted the version of each Nix package in the
# 17.03 channel. For now this Nix expression should only be used with 17.03,
# but I should eventually pin the channel with e.g.
#
#     let
#       nixpkgs = (import <nixpkgs> {}).pkgs.fetchgit {
#         url = "https://github.com/nixos/nixpkgs-channels";
#         rev = "???";
#         sha256 = "???";
#       };
#     in with import nixpkgs {};
#
# See:
# - https://github.com/NixOS/nixpkgs/issues/9682
#
# 2. OMERO Python Deps. I've managed to run successfully these build tasks
#
#     python build.py
#     python build.py release-clients
#     python build.py clean
#
# with just `setuptools` without all the other Python packages mentioned
# in the OMERO docs:
# - http://www.openmicroscopy.org/site/support/omero5.3/developers/installation.html#building-omero
# Probably most of those packages are actually only runtime but not build
# deps?
# Anyhoo, other build tasks may require additional packages, you can find
# the whole lot in `omero-5.3-dev.nix`.
