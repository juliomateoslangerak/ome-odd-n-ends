Release Procedure
=================
> How to release a new Smuggler and Offline Insight version.


Smuggler
--------
The building and packaging of Smuggler is fully automated, see the docs.
We document and track releases using GitHub issues, see e.g. the one for
version [1.1.0 beta][issue_v1.1.0-beta] and that for [1.2.0][issue_v1.2.0].
We also use GitHub to make the release bundles available, see the release
[page][smugs-releases].


Offline Insight
---------------
This is our modified `OMERO.Insight` that uses Smuggler to run imports in
the background. The release procedure is pretty much the same as for Smuggler
but there are a couple of things to keep in mind. First off, our modified
`OMERO.Insight` lives in the `offline-import` branch of MRI's fork of the
upstream `OMERO` repo. When they release, we merge their release tag into
our `offline-import` branch and then build our `OMERO.Insight` from this
branch. (We actually merge first into our corresponding `develop` branch
and then into `offline-import` from there; [diff][offline-diff] the two to
see what's going on.) Anyhoo, after building our Insight, we make it available
on a GitHub release [page][insight-releases]---btw, make sure the release
notes there link back to the corresponding Smuggler version.

### Building the client
You need to do this on a box with an OMERO build environment where you also
have installed a **licensed** version of `exe4j`. (Ask Julio for the license
MRI bought.) If you do that on Unix, you'll have to make sure `exe4j` gets
installed into `/opt/exe4j` since this path is hard-coded in the OMERO build
files.

To actually get the goodies, go to your local copy of the `offline-import`
branch and run:

    $ echo omero.version=5.4.0-Smuggler > etc/local.properties
    $ python build.py
    $ python build.py release-clients

The first command is to make sure our release bundles reflect this is our
modified `5.4.0 OMERO.Insight` (change the version number as appropriate!)
and that `5.4.0-Smuggler` will be shown at the bottom of the `OMERO.Insight`
splash screen too. If all went well, you should see the client bundles in
the `target` directory.




[insight-releases]: https://github.com/MontpellierRessourcesImagerie/openmicroscopy/releases
[issue_v1.1.0-beta]: https://github.com/c0c0n3/ome-smuggler/issues/11
[issue_v1.2.0]: https://github.com/c0c0n3/ome-smuggler/issues/14
[offline-diff]: https://github.com/openmicroscopy/openmicroscopy/compare/develop...MontpellierRessourcesImagerie:offline-import
[smugs-releases]: https://github.com/c0c0n3/ome-smuggler/releases
