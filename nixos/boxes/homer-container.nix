# sudo nixos-container create homer --config-file nixos/boxes/homer-container.nix
# sudo nixos-container update homer --config-file nixos/boxes/homer-container.nix
{ config, lib, pkgs, ... }:

with lib;
with import ../pkgs { inherit pkgs lib; };

{

#  boot.isContainer = true;
#  networking.hostName = mkDefault "homer";
#  networking.useDHCP = false;

  imports = [
    ../modules
  ];

  ext.users.admins = [ "andrea" ];

  environment.systemPackages = [
    omero.server
  ] ++ omero.deps.dev;

}
