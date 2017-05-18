#
# OMERO server installation module.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
with import ../../pkgs { inherit pkgs lib; };  # TODO move outta here!
{

  options = {
    omero.server.install.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Installs OMERO server on this machine.
      '';
    };
    omero.server.install.dir = mkOption {
      type = path;
      default = /var/lib;
      description = ''
        Where to install the OMERO server. This is the directory where we're
        going to unzip the server bundle which will create an OMERO.server
        sub-directory containing all the OMERO artifacts.
      '';
    };
    omero.server.repo.dir = mkOption {
      type = path;
      default = /OMERO;
      description = ''
        Location of the OMERO image repository.
      '';
    };
  };

  config = let
    enabled = config.omero.server.install.enable;
    install-dir = toString config.omero.server.install.dir;
    repo-dir = toString config.omero.server.repo.dir;
    server-user = config.omero.server.user;
  in mkIf enabled
  {
    omero.server.create-machine-account = true;

    environment.systemPackages = [
      (omero.packages.server.override {  # NOTE (1)
         omero-root = install-dir;
         omero-user = server-user.name;
         omero-group = server-user.group;
      })
    ];

    systemd.services.omero-server-install = {
      description = "One-off OMERO server initialisation.";

      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ omero.packages.server ];
      script = ''
        mkdir -p '${install-dir}'
        omero version || true

        if [ ! -d '${repo-dir}' ]
        then
          mkdir -p '${repo-dir}'
          chown ${server-user.name}:${server-user.group}
        fi
      '';  # NOTE (1) (2)

      serviceConfig.Type = "oneshot";
    };

  };

}
# Notes
# -----
# 1. OMERO installation hack. The `omero` command that ends up in the PATH
# is not the real one, just a wrapper that allows us to unzip the server
# bundle outside of the Nix store the first time we call it while it just
# runs the real OMERO command at every subsequent invocation. (Read the notes
# in `pkgs/omero/server.nix`.) The reason for `|| true` is that after the
# first service run we actually get to run the real `omero version` command
# which will fail when run as root causing the script to exit with an error
# and the unit entering the failed state. (NixOS starts Bash with `-e` see
# below.)
#
# 2. NixOS systemd scripts. If you use a service script, then you don't have
# to specify a `serviceConfig.ExecStart` because the NixOS systemd module will
# set it to point to the script generated from the `script` attribute. Also
# note the generated script already comes with a Bash shebang setting the `-e`
# flag, so we don't have to add it to the contents of the `script` attribute.
#
