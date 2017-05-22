#
# TODO
#
{ config, pkgs, lib, ... }:

with lib;
with types;
with import ../../pkgs { inherit pkgs lib; };  # TODO move outta here!
{

  config = let
    enabled = config.omero.web.enable;
    omero-pkg = omero.packages.server;
    install-dir = toString config.omero.server.install.dir;
    omero-prefix = "${install-dir}/${omero-pkg.name}";
    # TODO duplicated in server module. also path depends on where omero.server
    # package decides to extract zip. refactor to avoid nasty hidden code deps.
  in mkIf enabled
  {
    services.nginx.enable = true;
    services.nginx.virtualHosts.omeroweb = {

    };
  };

}
