#
# Nix expression to set up an OMERO 5.3 dev environment.
# You can use this environment both to build and run OMERO apps from the
# command line.
# Use with `nix-shell` on NixOS 17.03:
#
#     $ nix-shell omero-5.3-dev.nix
#
with import <nixpkgs> {};  # 17.03    NOTE (1)
with import ./prompt.nix;

let
  shell-name = "omero-5.3-dev";
in
runCommand "dummy"
{

  buildInputs = with python27Packages; [
    # OMERO runtime doesn't need the whole JDK, the JRE is enough.
    jdk         # openjdk-8u121b13

    # ICE for OMERO 5.3
    zeroc_ice   # 3.6.3

    # OMERO base Python deps.
    python27    # 2.7.13
    django      # 1.10.7
    pillow      # 3.4.2
    matplotlib  # 2.0.0
    numpy       # 1.11.3
    tables      # 3.2.2

    # Movie Maker (OMERO.scripts) needs `mencoder` but NixOS doesn't package
    # it separately from MPlayer.
    mplayer      # 1.3.0

    # OMERO.web additional deps.
    nginx        # 1.10.3
    gunicorn     # 19.3.0
  ];

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
