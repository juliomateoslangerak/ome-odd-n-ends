#
# OME Smuggler 0.1.0 package for NixOS 17.03.
#
{ # lib imports
  stdenv, fetchurl, lib, makeWrapper,
  # package dependencies from our OMERO packages
  jre
}:

with lib;

stdenv.mkDerivation rec {

  name = "ome-smuggler-${version}";
  version = "1.0.0";
  meta = {
    homepage = http://c0c0n3.github.io/ome-smuggler/;
    description = ''
      OMERO.smuggler is a Web-based work queue to run tasks on behalf of
      OMERO clients.
    '';
    license = licenses.gpl2;
  };

  src = fetchurl {
    url = "https://github.com/c0c0n3/ome-smuggler/releases/download/" +
          "v${version}/${name}.tgz";
    sha256 = "0nzxm55292ii22hphdkpf1b93g7x3s5842f7nfpav6j9dlyl63qn";
  };

  buildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/${name}

    cp lib/*.jar $out/share/${name}/

    makeWrapper ${jre}/bin/java $out/bin/smuggler \
      --add-flags "-jar $out/share/${name}/ome-smuggler-*.jar"
  '';

}
