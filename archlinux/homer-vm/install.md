Installed Software
==================

This VM starts as a clone of this [madematix][madematix]'s snapshot:
"Finished Customizations".


Version Control
---------------
        pacman -S git


Writing
-------
  * [Emacs Markdown Mode][md-mode]: (AUR) emacs-markdown-mode-git
  * Spell checking: `pacman -S aspell aspell-en`


Useful Tools
------------
  * Hardware: `pacman -S hwinfo hwdetect`
  * Disk: `pacman -S hdparm sdparm smartmontools`
  * Filesystems: `pacman -S ntfs-3g`
  * Network: `pacman -S ethtool tcpdump dnsutils nmap`
  * Commands: `pacman -S tree bc lsof`
  * Compression: `pacman -S fastjar unzip unrar cdrkit`
    (they all work with `lesspipe`)


Configuration
-------------
  * Load following modules in `~/.emacs`: spell, md.


[Java][arch-java]
------
Install only 8 runtime environment:

    sudo pacman -S jre8-openjdk

Add to `.xinitrc`:

    export _JAVA_AWT_WM_NONREPARENTING=1


[Python][arch-python]
--------
Install only Python 2.7:

    sudo pacman -S python2

and its package manager (pip):

    sudo pacman -S python2-pip

Tweak environment to change to Python 2 command:

* `sudo ln -s /usr/bin/python2 /usr/bin/python`
* `sudo ln -s /usr/bin/python2-config /usr/bin/python-config`

Install Python 2 libraries required for some OMERO server functionality:

    sudo pacman -S python2-numpy python2-matplotlib python2-pillow python2-pytables
    sudo pip2 install -I Django==1.8.12

###### NOTES
1. OME scripts use Python 2. Invoking them with the Python 2 interpreter (`python2`) is
not going to help because some of them call, in turn, other scripts that start with the
following shebang: `#!/usr/bin/env python`
which would result in an error. The above tweak will make any such script use Python 2.
2. Python 2's command is `/usr/bin/python2`, whereas Python 3's is `/usr/bin/python`.
Same applies to pip: `pip2` and `pip`. Because of the above tweak, **Python 3 should not
be installed** on this machine.
Another option would be to tweak the environment just for the `omero` user (see Arch
wiki) or, even better, write a script to switch environments along the lines of
`archlinux-java`.
3. `python2-pip` will install Python 2 set up tools: `python2-setuptools`.
4. NumPy for Python 2 installs: `usr/bin/f2py2`. This may have to be sym-linked to
`f2py` if OMERO calls it.
5. Pillow for Python 2 installs: `usr/bin/pil*2`. These may need sym-links too, as
explained above.
6. Same for PyTables in `usr/bin`: `pt2to3-2.7`, `ptdump-2.7`, `ptrepack-2.7`,
`pttree-2.7`.
7. Django needs to be installed through `pip2` as OMERO doesn't support versions above
`1.8`. There's a Pacman Django package for Python 2 is `python2-django` but it contains
Django `1.9.5`.


ICE
---
Need to build ICE C++, Java, and Python 2 only; the generated package must not have
the dependency on Python 3.  So we build in the `bart` VM after editing the PKGBUILD
to remove all PHP and Python 3 related stuff, then:

  * `makepkg --pkg=zeroc-ice`
  * `makepkg --pkg=zeroc-ice-python2`
  * `makepkg --pkg=zeroc-ice-java`
  * Install above packages (`zeroc-ice` first, then the others)

###### NOTES
1. C++. Tried to write Hello World app as per instructions in ICE manual, but failed to
compile; didn't investigate further.
2. Java. Building and running Hello World worked but following jar had to be added to
the class path:

    /usr/share/java/zeroc-ice/lib/Ice.jar

Also note that `$ICE_HOME` is not defined; it should probably be set to:

    /usr/share/java/zeroc-ice/

3. Python. Building and running Hello World worked out of the box.


[PostgreSQL][arch-postgres]
------------
**Install**

    sudo pacman -S postgresql 

**Initialize**

    sudo -i -u postgres
    initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'
    exit

**Set up service**

    sudo systemctl enable postgresql.service

Configure PostgreSQL to be accessible from any remote host:

 * Edit `/var/lib/postgres/data/postgresql.conf` to set `listen_addresses = '*'`.
 * Edit `/var/lib/postgres/data/pg_hba.conf` to add following line: 

        host    all             all             all			 md5

**Admin GUI**
Install [pgAdmin][pgadmin] to manage the server:

    sudo pacman -S pgadmin3

**XMonad**
Add key binding: `("M-x d", spawn "pgadmin3")`

###### NOTES
1. Security. With the above configuration, Postgres will accept TCP connections from any
host and any user provided they supply their MD5-encrypted password. Local users can still
connect without password. (This is enabled by the default Postgres configuration.)
Good for development but not for a production environment! (For example, only localhost
connections could be allowed if Postgres and OMERO are on the same machine, etc.)
2. Admin user. It is called `postgres` and you can connect locally without password:
`psql -U postgres`.
3. pgAdmin GUI. Connect using the `postgres` user (no pass). A dialog will pop up when
browsing the server objects asking you to install `adminpack`, which is installed already,
so just go ahead and hit the "Fix Me" button as suggested by the dialog instructions. 
4. Log file. To troubleshoot: `sudo journalctl -u postgresql`.


[Nginx][arch-nginx]
-------
**Install**

    sudo pacman -S nginx

**Set up service**

    sudo systemctl enable nginx.service

###### NOTES
1. Security. Just fine for development, but needs to be hardened (e.g. systemd+chroot) for
a production environment; also TSL/SSL needs to be installed and proper certificates used.
Perhaps in production it would be better to run the Web server on another box altogether
(e.g. in a DMZ) if this is at all supported by OMERO.


[MEncoder][arch-mencoder]
----------
Required to use Movie Maker script (one of the OMERO.scripts):

    sudo pacman -S mencoder


OMERO
-----
**Server User**
Create an `omero` user with password `abc123` to run the server: 

    sudo useradd -m -g users -s /bin/bash omero
    sudo passwd omero

Make `omero`'s home accessible to `users`, unzip the server bundle in it, and create a
convenience symlink:

    sudo chmod +rx /home/omero
    su omero
    cd ~
    unzip OMERO.server-5.2.2-ice35-b17.zip
    ln -s OMERO.server-5.2.2-ice35-b17 server

**Environment Variables**
Add the following to `/home/omero/.bashrc`:

    export OMERO_PREFIX=$HOME/server
    export OMERO_TMPDIR=/tmp
    export PATH=$PATH:$OMERO_PREFIX/bin

**Database**
Create Postgres user `omero` with password `abc123` and use same name `omero` to create
the DB associated to that user:

    sudo -u postgres createuser -P -D -R -S omero
    sudo -u postgres createdb -E UTF8 -O omero omero

**Repo**
Create the image repository:

    sudo mkdir /OMERO
    sudo chown omero:users /OMERO

**Config**

    su - omero
    cd server
    omero config set omero.db.name 'omero'
    omero config set omero.db.user 'omero'
    omero config set omero.db.pass 'abc123'
    omero db script --password 'abc123'
    psql -h localhost -U omero omero < OMERO5.2__0.sql

**Web Client**
Generate the Nginx config file for OMERO Web:

    omero web config nginx > omero-web.conf
    sudo mv omero-web.conf /etc/nginx/

Then edit `/etc/nginx/nginx.conf` to add the following lines in the `http` block:

    include omero-web.conf;

and these other three if not there already:

    sendfile on;
    send_timeout 60s;
    client_max_body_size 0;

Then comment out the default `server` block and restart Nginx:

    sudo systemctl restart nginx


###### NOTES
1. Server account. Creating a regular, unprivileged, user account to run the server is
all we need for development, but not the best solution for production where a "server"
account may be more appropriate. (e.g. no login shell, no home, etc.)
2. Service set up. In production, it may be best to run the server as a service using
`systemd`. In the long run, it may pay off to repackage and deploy the server so to
play well with Unix file system conventions...




[arch-java]: https://wiki.archlinux.org/index.php/Java
    "ArchLinux Wiki"

[arch-python]: https://wiki.archlinux.org/index.php/Python
    "ArchLinux Wiki"

[arch-postgres]: https://wiki.archlinux.org/index.php/PostgreSQL
    "ArchLinux Wiki"

[pgadmin]: http://www.pgadmin.org/
    "pgAdmin Web Site"

[arch-nginx]: https://wiki.archlinux.org/index.php/Nginx
    "ArchLinux Wiki"

[arch-mencoder]: https://wiki.archlinux.org/index.php/MEncoder
    "ArchLinux Wiki"

[madematix]: https://github.com/c0c0n3/archlinux/tree/master/vm/src/installation-guide
    "base vm"
