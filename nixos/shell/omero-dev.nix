#
# Nix expression to set up an OMERO dev environment for the latest OMERO
# release in our Nix packages.
# You can use this environment both to build and run OMERO apps from the
# command line.
# Use with `nix-shell` on NixOS 17.03:
#
#     $ nix-shell omero-5.3-dev.nix
#
with import <nixpkgs> {};  # 17.03    NOTE (1)
with import ./util.nix;
with import ../pkgs { inherit pkgs lib; };

let
  shell-name = "omero-dev";
in
runCommand "dummy"
{

  buildInputs = omero.deps.dev;

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
