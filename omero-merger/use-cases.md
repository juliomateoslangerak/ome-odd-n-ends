Use Cases
=========
The core functionality we need to keep in any merger with OMERO is that
of a resilient background OMERO import with outcome notifications as
detailed in sections 1 to 3 below. **Whatever we do, we must have this
functionality in a future OMERO release**, well, as long as we want MRI
to pay for another year of dev. 

Sections 4 to 6 point out other features we've built into Smuggler MRI
are not using at the moment so we could leave them behind, i.e. they're
nice-to-haves at this stage.

1. OMERO Background Import
--------------------------
Acquisition workstation users have to be able to kick-off an OMERO import
and logout of the workstation immediately after without having to wait for
the import to complete. So the import should run in a background process
outside of any user sessions. An OMERO user must have some kind of GUI
to let them pick one or more files to import in the background and then
submit them to the system as a single import batch.

### Notes
1. *Background Process*. The fact the process has to run outside of user
sessions doesn't necessarily imply it also has to sit on the same acquisition
workstation where the user originally triggered the import. For the sake
of a merger though, it's enough to just support a background process on
each acquisition workstation as this is how we've set up Smuggler at MRI.
2. *Import GUI*. We use a modified Insight at the moment, but in principle
there's no reason why we couldn't use something else. Web import anyone?

2. Notifications
----------------
If we take imports out of a user's hands into our own, then we have to give
them some kind of feedback re: import status and outcome. Smuggler provides
both, but for the sake of a merger, we only require outcome notifications.
Specifically, after processing all the files in an import batch, the system
must send an email to the user who submitted the batch with a success/failure
outcome report. On top of that, if any of the files in the batch failed,
the sys admin gets an email alert too.

3. Resilience
-------------
In a background import scenario, the user who triggered the import has no
easy way to restart it if something goes wrong. So the system should take
care of that with configurable retries. Also background imports should be
persistent: if the background import process dies of a horrible death (e.g.
the user kindly shut the machine down) the import is not lost and gets
resumed when restarting the background import process. The same applies
to email notifications: we have to be able to cope with transient failures
(e.g. mail server's down) and eventually send out those emails.

4. Configuration
----------------
You can configure most of what Smuggler can do, see the docs [section][cfg].
We don't have to keep it, but it's a nice to have I reckon?

5. Monitoring
-------------
Smuggler comes with remote monitoring to make a sys admin's life less
hellish. (Details over [here][monitor].) We don't have to have this either
cos MRI IT aren't using it at the moment. But, IMHO, it's something highly
desirable in any large scale deployment.

6. Packaging
------------
We support three kinds of deployment scenarios: standalone server, Windows
service and Linux daemon. (Details over [here][deploy].) For each of them,
we generate a corresponding release bundle as part of the automated build
process. Depending on how we repackage Smuggler into OMERO we may want to
keep some of this.




[cfg]: http://c0c0n3.github.io/ome-smuggler/docs/content/deployment/configuration.html
    "Configuration"
[deploy]: http://c0c0n3.github.io/ome-smuggler/docs/content/deployment/index.html
    "Deployment"
[monitor]: http://c0c0n3.github.io/ome-smuggler/docs/content/deployment/monitoring.html
    "Monitoring"
