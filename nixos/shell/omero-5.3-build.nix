#
# Nix expression to set up an OMERO 5.3 build environment.
# Use with `nix-shell` on NixOS 17.03:
#
#     $ nix-shell omero-5.3-build.nix
#
with import <nixpkgs> {};  # 17.03    NOTE (1)
with import ./prompt.nix;

let
  shell-name = "omero-5.3-build";
in
runCommand "dummy"
{

  buildInputs =
    [ jdk ] ++             # openjdk-8u121b13
    [ zeroc_ice ] ++       # 3.6.3
    [ python27 ] ++        # 2.7.13
    (with python27Packages; [        # NOTE (2)
      django               # 1.10.7
      pillow               # 3.4.2
      matplotlib           # 2.0.0
      numpy                # 1.11.3
      tables               # 3.2.2
    ]);

  shellHook = ''
    ${setPrompt { inherit shell-name; }}
    export SLICEPATH="${zeroc_ice}/slice"
  '';

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
# 2. OMERO Python Deps. I've managed to run successfully `python build.py`
# and `python build.py release-clients` with just `setuptools` (30.2.0)
# without all the other Python packages which I think are runtime but not
# build deps?
