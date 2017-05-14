with import <nixpkgs> {};

let
  omero = (import ./default.nix { inherit pkgs; }).omero;
  target = omero.packages.db.bootstrap;
in
stdenv.mkDerivation rec {

  name = "test";

  buildInputs = [ target ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out
    ln -s ${target} $out/target
  '';

}
