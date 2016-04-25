FBI Project Report
==================
Minimal project report for FBI to summarise work on Smuggler up to end of
April 2016. Just focusing on data management as this is what FBI paid for.
As I explained in the past, to me data management is not the end but the
means to distributed data mining of biological image data and metadata;
however, if we want to go down that road we'll need a separate grant, so
I reckon it's pointless to even mention it here.


Project Description
-------------------
We investigate Web-based, message-driven software architectures for
distributed storage, transfer, management, visualisation, and analysis of
biological microscopy data within the Open Microscopy Environment (OME),
which has been adopted at MRI as the base data management platform.


Project Outputs up to 25 April 2016
-----------------------------------
We have delivered the following:

1. A REST-based, message-driven, fault-tolerant, scalable, distributed
architecture for managing image data within the OMERO platform and for
integrating with other external software.
2. Building on (1), a Web service to run image data transfers on behalf of
OMERO clients and outside of user sessions so to increase availability of
acquisition workstations and avoid facility users being billed for data
transfers. The source code is publicly available at:
[https://github.com/c0c0n3/ome-smuggler](https://github.com/c0c0n3/ome-smuggler).
3. A documentation Web site for the above, publicly available at:
[http://c0c0n3.github.io/ome-smuggler/docs/content/](http://c0c0n3.github.io/ome-smuggler/docs/content/).

The software is currently being tested by facility managers and should be
deployed to end users at the end of May 2016. The team has joined the OME
Consortium to further the OMERO platform in order to provide an improved
service to facility users and managers alike.


Future Work
-----------
In order to further improve the service offered by MRI, we would like to
build on the foundation we have laid to implement software components to
provide additional functionality currently needed by facility managers but
not provided by the OMERO platform: A framework for the collection of
microscope metrics; offline, efficient, and reliable FTP; automated management
of data storage on acquisition workstations.


Considerations
--------------
Large imaging facilities like MRI need a robust solution to manage ever
increasing amounts of image data.
MRI has adopted the OME software suite as from image acquisition to publication,
OME provides the infrastructure needed to manage the entire process in an
automated, secure, and reliable fashion, catering for the storage, transfer,
management, visualisation, analysis, sharing and publication of image data
and metadata. Given that MRI has committed to using OME, it seems reasonable
to continue investing in the development of the OME platform.

