Deployment Procedure
====================
> How to deploy a new Smuggler and Offline Insight version.

Below is a sum up of what we discussed with IT regarding deployment at the
various MRI campuses. The actual procedure to follow depends on what IT
decide to do in the end. We're going to roll out a Smuggler server and
an `Offline OMERO.Insight` client on each and every acquisition workstation.

Prep Steps
----------
First [download][smugs-releases] the Smuggler release matching our OMERO
server. Then unpack it and configure it for MRI deployment by adding our
own import and mail configuration settings specific to MRI:

* [import.yml][import-config]: the import settings; copy this file over
as is.
* [mail.yml][mail-config]: the mail settings; you need to edit this file
to specify a mail `password` and possibly a `sysAdminEmail`.

Once you're done, repackage Smuggler and make it available somewhere on
the intranet where you can easily download it from the various acquisition
workstations.

Deploying on a Workstation
--------------------------
* Log in as `standarduser`.
* Download the repackaged version of Smuggler---see above.
* [Download][insight-releases] the offline Insight client.
* Make sure Smuggler's import queue is empty.
* Stop Smuggler.
* Optionally copy `ome-smuggler` from `Program Files` to a backup location
for later data analysis.
* Delete `ome-smuggler` and `OMERO.insight-*-Smuggler` from `Program Files`.
* Extract the Smuggler and offline client bundles to `Program Files`.
* Start Smuggler's service.
* Look at Smuggler's log file to make sure it's honky dory.
* Clean up old Insight Desktop shortcuts and make a new one pointing to
`OMERO.insight-*-Smuggler` named `OMERO Insight`.
* Run `update-standarduser.exe` then reboot.
* Log in as a regular user.
* Import some data and look at Smuggler's log file to make sure there are
no errors.

Rinse and repeat for each and every machine. Note the instructions above
assume Smuggler was already installed. If that's not the case, you have
to install Smuggler as explained in the docs.


Deployment History
------------------
We've had several QA, internal, and prod deployments here at the IGH--see
below. MRI-wide deployment is planned for November 6, 2017.

1. *April 2016*. Initial QA deployment.
2. *May 2016*. QA deployment following a bug-fixing release of the offline
client.
3. *June 2016*. QA deployment following a bug-fixing release of the offline
client.
4. *July 2016*. First internal deployment at IGH of Smuggler and offline
client for OMERO `5.2`.
5. *August 2016*. QA deployment following the introduction of a new set
of features in Smuggler.
6. *October 2016*. Second internal deployment at IGH.
7. *March 2017*. First official prod deployment at IGH.
8. *March 2017*. Second official prod deployment at IGH following a bug-fixing
release of the offline client and new features in Smuggler---see the details
[here][deployment-17-mar-2017].




[deployment-17-mar-2017]: deployment.17-Mar-2017.md
[import-config]: config/import.yml
[insight-releases]: https://github.com/MontpellierRessourcesImagerie/openmicroscopy/releases
[mail-config]: config/mail.yml
[smugs-releases]: https://github.com/c0c0n3/ome-smuggler/releases
