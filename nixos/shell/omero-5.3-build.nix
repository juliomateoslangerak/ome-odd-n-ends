#
# Nix expression to set up an OMERO 5.3 build environment.
# Use with `nix-shell` on NixOS 17.03:
#
#     $ nix-shell omero-5.3-dev.nix
#
with import <nixpkgs> {};  # 17.03

runCommand "dummy"
{

  buildInputs =
    [ jdk ] ++             # openjdk-8u121b13
    [ zeroc_ice ] ++       # 3.6.3
    [ python27 ] ++        # 2.7.13
    (with python27Packages; [
      django               # 1.10.7
      pillow               # 3.4.2
      matplotlib           # 2.0.0
      numpy                # 1.11.3
      tables               # 3.2.2
    ]);

  shellHook = ''
    export SLICEPATH="${zeroc_ice}/slice"
  '';

} ""
