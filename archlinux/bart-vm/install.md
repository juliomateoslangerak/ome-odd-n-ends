Installed Software
==================

This VM starts as a clone of this [madematix][madematix]'s snapshot:
"Base Development Environment".

[Java][arch-java]
------
Install both Java 7 and 8 development environment:

    sudo pacman -S jdk7-openjdk openjdk7-src
    sudo pacman -S jdk8-openjdk openjdk8-src

Add to `.xinitrc`:

    export _JAVA_AWT_WM_NONREPARENTING=1

**NOTES**
1. Use `archlinux-java` to switch between Java environments.
2. Not installing Java Docs (`openjdk7-doc`, `openjdk8-doc`) as they're best viewed and
queried through Google. Also Eclipse doesn't need them.


[Eclipse (Mars)]
----------------
**Core Installation**
* Download and install in home directory:

        cd ~
        tar xzf eclipse-java-mars-1-linux-gtk-x86_64.tar.gz
        mv eclipse eclipse-mars
    
* Set Dark theme: *Window / Preferences / General / Appearance*
* Add JDK 7 (JDK 8 would be picked up by default) to Eclipse's JRE's.
  (`src.zip` should be picked up automatically; docs will be online)
* Optionally install plugins: Data Tools Platform, Eclipse Java EE Developer
  Tools, Eclipse Web Developer Tools, JavaScript Development Tools, Maven
  (Java EE) Integration for Eclipse WTP, TestNG.

**Text Editors**
* Tab width = 4 and insert spaces for tabs in *Window / Preferences / General /
  Editors / Text Editors*
* Show print margin (same dialog as above)
* Define new Java formatter profile from existing "Java Conventions" to specify spaces
  only tab policy and tab width = 4: *... / Preferences / Java / Code Style / Formatter*

**Look & Feel**
* Install plugin: Eclipse Color Theme; select Solarized Dark in *Window / Preferences
  / General / Appearance*
* Set Monaco 13 for Text Editor and Text Block fonts: *... / Appearance / Colors and Fonts*

**XMonad**
* Add key binding: `("M-x i", spawn "/home/andrea/eclipse-mars/eclipse")`

**Gradle**
* (AUR) gradle

Notes
-----
1. *Eclipse Screen Rendering.* It seems sometimes damaged regions are not repainted. Also
the built-in dark theme doesn't seem to work as some elements remain light and button text
is unreadable. This affects the Eclipse Moonrise UI Theme, so don't bother installing it.

[Python][arch-python]
--------
Install both Python 3.4 and 2.7:

    sudo pacman -S python python2

and the Python package manager (pip) for both versions:

    sudo pacman -S python-pip python2-pip

Tweak environment to default to Python 2:

* `mkdir ~/bin`
* `ln -s /usr/bin/python2 ~/bin/python`
* `ln -s /usr/bin/python2-config ~/bin/python-config`
* edit `PATH` in `~/.bashrc`: `PATH=~/bin: ...all the rest...`

**NOTES**
1. OME scripts use Python 2. Invoking them with the Python 2 interpreter (`python2`) is
not going to help because some of them call, in turn, other scripts that start with the
following shebang:

    #!/usr/bin/env python

which would result in the Python 3 interpreter being called. The above tweak will make
any such script use Python 2 instead of 3.
2. Python 2's command is `/usr/bin/python2`, whereas Python 3's is `/usr/bin/python`.
Same applies to pip: `pip2` and `pip`. Because of the above tweak, Python 3 will have
to be called with the whole path (`/usr/bin/python`) if logged in as `andrea`.
Another option would be not to modify `PATH` permanently in `.bashrc` and instead run
`export PATH=~/bin:$PATH` just for the current shell session or, even better, write a
script to switch environments along the lines of `archlinux-java`.
3. `python-pip` and `python2-pip` will install Python set up tools; one for each version
of Python: `python2-setuptools` and `python-setuptools`.


ICE
---
First install some Java libraries required to build ICE for Java:

  * (AUR) jgoodies-common (ICE requires 1.8.0 which is no longer available from the
          JGoodies archives; so we use 1.8.1)
  * (AUR) jgoodies-looks; use my custom PKGBUILD to build 2.6.0 instead of `aur.url`
          (latest won't make ICE compile!)
  * (AUR) jgoodies-forms; use my custom PKGBUILD to build 1.8.0 instead of `aur.url`
          (latest won't make ICE compile!)
  * (AUR) java-berkeleydb
      NB: before running `makepkg`, you have to switch to JDK 7 (won't build under 8);
      switch back to 8 after installing the package.

To install ICE 3.5.1 from AUR:

  * Set up AUR directory as usual for package: `zeroc-ice`.
  * Download and extract.
  * Edit PKGBUILD to remove all PHP-related stuff.
  * `makepkg --pkg=zeroc-ice`
  * `makepkg --pkg=zeroc-ice-python2`
  * `makepkg --pkg=zeroc-ice-python`
  * `makepkg --pkg=zeroc-ice-java`
  * Install above packages (`zeroc-ice` first, then the others)

**NOTES**
1. ICE build requires Ant, which will then be installed at this stage.

OMERO
-----
To build OMERO, we still need one dependency:

    sudo pacman -S python2-genshi

**NOTES**
1. Genshi is not available for Python 3 in Arch (not even in the AUR!) 






[arch-java]: https://wiki.archlinux.org/index.php/Java
    "ArchLinux Wiki"

[arch-eclipse]: https://wiki.archlinux.org/index.php/Eclipse
    "ArchLinux Wiki"

[arch-python]: https://wiki.archlinux.org/index.php/Python
    "ArchLinux Wiki"

[madematix]: https://github.com/c0c0n3/archlinux/tree/master/vm/src/installation-guide
    "base vm"
