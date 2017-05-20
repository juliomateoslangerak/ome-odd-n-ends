# sudo nixos-container create homer --config-file nixos/boxes/homer-container.nix
# sudo nixos-container update homer --config-file nixos/boxes/homer-container.nix
{ config, lib, pkgs, ... }:

with lib;
# with import ../pkgs { inherit pkgs lib; };
{

#  boot.isContainer = true;
#  networking.hostName = mkDefault "homer";
#  networking.useDHCP = false;

  networking.hostName = "localhost";
  # NB this seems to fix the exception thrown by InetAddress.getLocalHost
  # when running Java in a NixOS container. OMERO indirectly calls this
  # method at start up, so we need this fix.

  imports = [
    ../modules
  ];

  ext.users.admins = [ "andrea" ];

  omero = {
    server.enable = true;
    db = {
      enable = true;
      user.password = "abc123";
    };
    users.root.password = "abc123";
  };
/*
  environment.systemPackages = [
    pkgs.unzip
    omero.packages.server
    omero.packages.db.bootstrap
  ] ++ omero.deps.dev;
*/
}
