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

    db-name = config.omero.db.name;
    db-user = config.omero.db.user.name;
    db-pass = config.omero.db.user.password;
    db-host = config.omero.db.host;
    db-port = toString config.omero.db.port;

    omero-set-config = k: v:
    let
      omero-cmd = ''omero config set ${k} '${v}' '';
    in  # NOTE (3)
      ''runuser ${server-user.name} -c ${escapeShellArg omero-cmd} '';

    server-list =
      let
        servers = mapAttrsToList
                    (n: v: ''["${v.host}", ${toString v.port}, "${n}"]'');
        serialise = submod:
          let
            xs = concatStringsSep ", " (servers submod);
          in "[${xs}]";
      in
        serialise config.omero.web.server-list;
    #
    # serialise { x = { host="h1"; port=1; }; y = { host="h2"; port=2; }; }
    # ~~~> string: [["h1", 1, "x"], ["h2", 2, "y"]]

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
      description = "One-off OMERO server initialisation";

      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ omero.packages.server pkgs.utillinux ];
      script = ''
        mkdir -p '${install-dir}'
        omero version || true

        ${omero-set-config "omero.db.name" db-name}
        ${omero-set-config "omero.db.user" db-user}
        ${omero-set-config "omero.db.pass" db-pass}
        ${omero-set-config "omero.db.host" db-host}
        ${omero-set-config "omero.db.port" db-port}
        ${omero-set-config "omero.web.application_server" "wsgi-tcp"}
        ${omero-set-config "omero.web.server_list" server-list}

        if [ ! -d '${repo-dir}' ]
        then
          mkdir -p '${repo-dir}'
          chown ${server-user.name}:${server-user.group} '${repo-dir}'
        fi
      '';  # NOTE (1) (2) (4)

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";  # NOTE (5)
      };
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
# 3. Server User. We're using this account with `runuser`, assuming the server
# user has a login, which would be better not to. However, it seems OMERO too
# assumes the user it's run with has a login---see note in `server-users`. So
# for the moment, we recycle the server account instead of creating another
# (non-root) user just for this task.
#
# 4. Passwords. TODO. Same issue as already noted in `db.nix` module.
#
# 5. Service status. We need to tell `systemd` to consider this service still
# active after exit otherwise `systemd` won't start services that "bind" to
# it, notably our very own `omero.service`!
#
