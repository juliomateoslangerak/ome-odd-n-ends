# sudo nixos-container create homer --config-file nixos/boxes/homer-container.nix
# sudo nixos-container update homer --config-file nixos/boxes/homer-container.nix
{ config, lib, pkgs, ... }:

with lib;

{

#  boot.isContainer = true;
#  networking.hostName = mkDefault "homer";
#  networking.useDHCP = false;

  imports = [
    ../pkgs
  ];

  environment.systemPackages = with pkgs; with config.pkgs; [
    omero-server
  ];

}
