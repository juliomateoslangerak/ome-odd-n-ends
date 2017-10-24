IGH Deployment
==============
> Smuggler's deployment at IGH on Fri 17 Mar 2017.

This is the second prod deployment, the first one happened a week ago.
We installed a new version of:

* Insight with several bug fixes---see email I sent out on Fri 17.
* Smuggler with a new feature: notifying sys admin on each import failure.

We deployed on all analysis and acquisition workstations except for OMX.

Directory Contents
------------------
* `OMERO.insight-5.2.3-Smuggler`. Our latest Insight Windows version,
unzipped after building.
* `ome-smuggler`. Latest Smuggler Windows service, unzipped after building
and configured with MRI settings---see `config` directory.
* `machines`. A copy of Smuggler's directory as it was on each IGH machine
before reinstalling this new version. In each directory, you'll find all of
Smuggler's data since the first IGH roll out a week ago. Note that last week
we deployed on less machines---just in case you're wondering why some machine
data is not there.

Deployment Procedure
--------------------
* Copy `OMERO.insight-5.2.3-Smuggler` and `ome-smuggler` to a memory stick.
* On the target machine, log in as `standarduser`.
* Make sure Smuggler's import queue is empty.
* Stop Smuggler.
* Copy `ome-smuggler` from `Program Files` to a backup location for later
data analysis.
* Delete `ome-smuggler` and `OMERO.insight-5.2.3*` from `Program Files`.
* Copy `ome-smuggler` and `OMERO.insight-5.2.3*` from the memory stick to
`Program Files`.
* Start Smuggler's service.
* Look at Smuggler's log file to make sure it's honky dory.
* Clean up old Insight Desktop shortcuts and make a new one pointing to
`OMERO.insight-5.2.3-Smuggler` named `OMERO Insight`.
* Run `update-standarduser.exe` then reboot.
* Log in as a regular user.
* Import some data and look at Smuggler's log file to make sure there are
no errors.

Rinse and repeat for each and every machine. Note the instructions above
assume Smuggler was already installed. If that's not the case, you have
to install Smuggler as explained in the docs.

