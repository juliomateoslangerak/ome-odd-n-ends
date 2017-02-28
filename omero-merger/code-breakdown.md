Codebase Breakdown
==================
The code is pretty much arranged in the same way as OMERO with a top-level
components dir and subdirs for each major component. The core components
are called `server`, `util`, and `packager`. I've also got another two,
`cli` and `jclient`, that I don't think we'll need going forward though.

server
------
Spring Boot (booty?) app to queue and run tasks. Besides the import, I've
implemented a couple of generic tasks (file streaming, emails) as well as
an OMERO session keep-alive server. Moreover I've built an encryption layer
to secure data stored on disk.

+ **code**: 7425 LOC
+ **docs**: 3803 lines
+ **test**: 6309 LOC

Out of all this code, approx 2500 lines implement the MRI-specific use
cases I've mentioned earlier.

util
----
General-purpose Java 8 lib, reusable across projects---i.e. there's nothing
specific to Smuggler in here.

+ **code**: 2249 LOC
+ **docs**: 2373 lines
+ **test**: 3330 LOC

packager
--------
Groovy app packager. (Groovy as in the Groovy language, not as in groovy
cool :-) Automates the building of release bundles.

+ **code**: 428 LOC
+ **docs**: 74  lines

cli
---
OMERO import lib wrapper. Smuggler can't use the import lib directly cos
there's classpath conflicts: Blitz depends on Spring 3 but Smuggler brings
in Spring 4. So I ended up running the import in a separate JVM with its
own classpath. We can ditch this as soon as we find a better solution.

+ **code**: 373 LOC
+ **docs**: 156 lines

jclient
-------
Java 7 client to interact with Smuggler. Only used to trigger an import
from Insight, so we can ditch this too as soon as we decommission Insight.
Anyhoo, most of this code is reusable HTTP/JSON stuff...

+ **code**: 506 LOC
+ **docs**: 402 lines


