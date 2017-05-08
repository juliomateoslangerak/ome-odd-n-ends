#
# OMERO dependency sets.
#
{ omero-pkgs }:

with omero-pkgs;
rec {

  # Python env to run OMERO server, web and CLI tools.
  py-runtime = pyenv [  # NOTE (1)
    django
    django-pipeline
    gunicorn
    matplotlib
    numpy
    omero-marshal
    pillow
    tables
    zeroc-ice-py
  ];

  # Packages required to run OMERO server, web and CLI tools.
  runtime = [
    jre
    zeroc_ice
    mencoder
    py-runtime
  ];

  # Base dev env for OMERO components.
  dev = [
    jdk
    zeroc_ice
    mencoder
    py-runtime
  ];

  # Packages required to build OMERO components with `build.py`.
  build = [
    jdk
    zeroc_ice
    (pyenv [
      setuptools  # NOTE (2)
    ])
  ];

}
# Notes
# -----
# 1. OMERO Python Runtime Deps. I think most of these Python packages above
# are only needed by OMERO.web, so we could split the runtime dependency set
# into two: Web and server deps?
#
# 2. OMERO Python Build Deps. I've managed to run successfully these build
# tasks
#
#     python build.py
#     python build.py release-clients
#     python build.py clean
#
# with just `setuptools` without all the other Python packages mentioned
# in the OMERO docs:
# - http://www.openmicroscopy.org/site/support/omero5.3/developers/installation.html#building-omero
# Probably most of those packages are actually only runtime but not build
# deps? Anyhoo, other build tasks may require additional packages...
#
