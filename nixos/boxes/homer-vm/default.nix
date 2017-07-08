#
# Bare-bones VirtualBox VM to run a full OMERO stack (including Smuggler)
# on a single box.
#
{ config, lib, pkgs, ... }:

let
  adminName = "andrea";
in
{

  imports = [
    # Include base system config. (NOTE lifted from trixie-dotses)
    ./core.nix
    # Incude OMERO modules.
    # NOTE swap-file and users modules lifted from trixie-dotses
    ../../modules
  ];

  ##########  Core System Setup  ###############################################

  # Use a swap file.
  ext.swapfile.enable = true;

  # Networking settings.
  networking = {
    hostName = "homer";
    firewall.enable = false;  # NOTE (1)
  };

  # Hide boot loader menu. The loader will boot the latest NixOS generation.
  # NB you won't be able to rollback to an earlier NixOS generation at boot.
  boot.loader.timeout = 0;

  # VBox setup:
  # - enable virtualbox guest service (even though hardware-configuration.nix
  #   enables it already, we add it here too to make it more visible)
  # - skip fsck on boot cos it won't work with VBox
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;

  ##########  Services  ########################################################

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  ##########  Users  ###########################################################

  # Add an admin user.
  ext.users.admins = [ adminName ];

  ##########  OMERO Stack  #####################################################

  # Set up a complete OMERO environment.
  omero = {
    server.enable = true;
    db = {
      enable = true;
      user.password = "abc123";
    };
    web.enable = true;
    users.root.password = "abc123";

    smuggler.enable = true;
  };

  ##########  Additional Software  #############################################

  # Install extra packages that may come in handy.
  environment.systemPackages = with pkgs; [
     git
     emacs
  ];

}
# Notes
# -----
# 1. Security. You most likely want to turn the firewall on (and open ports
# as needed) if you put the VM on the network. The default VirtualBox network
# config (NAT) makes your VM invisible from outside your host so running a
# firewall in the guest is sort of pointless which is why we're turning the
# guest firewall off by default.
#
