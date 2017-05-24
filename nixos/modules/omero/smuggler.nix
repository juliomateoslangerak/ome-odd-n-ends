#
# Runs Smuggler as a `systemd` service.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
with import ../../pkgs { inherit pkgs lib; };  # TODO move outta here!
{

  options = {
    omero.smuggler.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables Smuggler on this machine.
      '';
    };
    omero.smuggler.username = mkOption {
      type = string;
      default = "smuggler";
      description = "User name of the account under which Smuggler runs.";
    };
    omero.smuggler.group = mkOption {
      type = string;
      default = "smuggler";
      description = "Group under which Smuggler runs.";
    };
    omero.smuggler.data-dir = mkOption {
      type = path;
      default = "/var/db/smuggler";
      description = ''
        Smuggler's data directory.
      '';
    };
    omero.smuggler.config-dir = mkOption {
      type = path;
      default = "/etc/smuggler";
      description = ''
        Smuggler's configuration directory.
      '';
    };
  };

  config = let
    cfg = config.omero.smuggler;
    bin-smuggler = "${omero.packages.smuggler}/bin/smuggler";

    ensureDir = d: ''
      mkdir -p '${d}'
      chmod 700 '${d}'
      chown -R ${cfg.username}:${cfg.group} '${d}'
    '';
  in mkIf cfg.enable
  {
    users.users."${cfg.username}" = {
      name = cfg.username;
      group = cfg.group;
    };
    users.groups."${cfg.group}".name = cfg.group;

    systemd.services.smuggler = {
      description = "Smuggler";

      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ${ensureDir cfg.config-dir}
        ${ensureDir cfg.data-dir}
      '';

      environment.SMUGGLER_CONFIGDIR = cfg.config-dir;
      environment.SMUGGLER_DATADIR = cfg.data-dir;

      serviceConfig = {
        User = cfg.username;
        PermissionsStartOnly = true;  # NOTE (1)
        ExecStart = bin-smuggler;
        SuccessExitStatus = "143";    # NOTE (2)
        Restart = "always";
        StartLimitIntervalSec = "90";
        StartLimitBurst = "3";
      };
    };
  };
}
# Notes
# -----
# 1. Service User. We use a dedicated service account to run Smuggler, but
# to create service directories we need to be root. Which is why we use
# PermissionsStartOnly.
#
# 2. Exit Status. Apparently when running as a `systemd` service,  SpringBoot
# will exit with a status of 143 for success. Here we're making `systemd` aware
# this so that it doesn't flag our service as being exited uncleanly. You'll
# find this setting in the SpringBoot `systemd` example too, though they don't
# explain why:
# https://docs.spring.io/spring-boot/docs/current-SNAPSHOT/reference/htmlsingle/#deployment-systemd-service
#
