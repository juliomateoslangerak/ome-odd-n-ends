Web of Open Microscopy Environments (WOME?!)
===================================
I would like to explore the idea of a web of OME's. It would be a distributed
information space of interlinked resources based on the model of the World Wide
Web: Potentially any piece of information as identified by the OME data model
could count as a resource and it should be possible to create links among any
number of resources, possibly even references to data external to OME.

Why? Connecting data sources can lead to the acquisition of new knowledge that
would not have been possible to extract from each individual data source in
isolation. Currently aggregation and mining can happen within one OME database,
but it is not hard to picture scenarios where one may want to carry out this
process across many OME databases, leading to a distributed web of interlinked
OME sites.

Ideally we should not get bogged down with a purely technical discussion,
but rather collect different ideas, views and opinions as well as exploring
potential, challenges and opportunities.
Below are the contents of a 10-minute talk to frame the discussion.


Aggregating Data to Extract New Knowledge
-----------------------------------------
Scientific knowledge is produced not only by studying phenomena in isolation
but also (crucially!) by discovering relationships among them. After knowledge
has been extracted from isolated data sets, often even more can be discovered
once these data are brought together and mined.
(E.g. Darwin relates species, variations, and habitat; he then reasons that
species may adapt to changes in the environment, leading to alterations of
the race...)

Computers allow scientists to acquire ever increasing amounts of data to make
observations and test predictions. But computers have also accelerated the
process (once performed by humans only!) of data aggregation, correlation and
pattern discovery, resulting in new knowledge being produced at unprecedented
rates in many fields.
Perhaps, the most exciting aspect of "Big Data" is not that we are producing
oceans of bytes, but rather that there are potentially many interesting
relationships among diverse data sets which are yet to be discovered and
availability of these data sets for analysis makes discovery possible.
The key observation here is that connecting data sources can lead to the
acquisition of new knowledge that would not have been possible to extract
from each individual data source in isolation.
(Darwin had to examine many diverse data sets to put together the pieces of
the evolution puzzle.)


Big Data Islands
----------------
Traditionally biologists who do imaging tend to work on their own data sets
in isolation, producing knowledge that is eventually published in a paper and
connections among different studies may only be realised much later down the
line by someone examining those studies. Even then, much could potentially
still remain undiscovered simply because all the relevant data supporting the
studies (images and analysis) are not available. Although these individual data
sets may be large, they are not connected---just like islands in an ocean.

As increasingly more research institutions urge biologists to make available
the data supporting published studies, we have an opportunity to aggregate
data (images, measurements, results, etc.) from diverse sources and have
machines mine the aggregate to extract new knowledge with the potential to
accelerate the process of scientific discovery.
An alluring prospect, but certainly as challenging as alluring. While there
are many stumbling blocks (dealing efficiently with large amounts of data,
building conceptual bridges among very different imaging domains, coping with
unstructured or poorly annotated data, perturbations in the experimental data,
etc.) and definitely no silver bullet, some progress can still be made.


Even Bigger Data
----------------
OME has undoubtedly proven its value as a data management and integration
platform, but also has the potential to deliver a solid foundation for mining
biological imaging data sets aggregated from different studies. A case in point
is the IDR project which aims to extract feature sets out of multiple studies
with the hope to deliver some measure of similarity in terms of image structure,
dynamics and components.

Currently aggregation and connection happens within one OME database, but it
is not hard to picture scenarios where one may want to carry out this process
across many OME databases, leading to a distributed web of interlinked OME
sites. But how to connect data from two different OME sites and store the
new relationships in a third site? For example, suppose a biologist found an
interesting connection between an ROI along with some associated measurements
in one OME site and an annotated data set in another site. How would she store
these new data in her own OME site along with annotations to explain the
connection she made? Could the resulting information space be made easily
navigable both by humans and machines? As easy, say, as browsing the Web?

If we could build such a web of Open Microscopy Environments (WOME?!), it
could provide the means to accelerate the flow of scientific information
among imaging biologists with the potential to also speed up the pace at
which connections among studies are made. For example, a biologist might
happen to find a pattern in two images from different sites by dint of
them being linked to some other resource she was browsing. Crowd-sourcing
the hunt for similarities in imaging data would be another example. (And
it might even work as many have a stake in the research some biologists do,
e.g. cancer research.) For a related example in another field, consider a
programmer putting together several answers from a Q&A site like Stack
Overflow to quickly come up with a solution to her own problem. This
happens routinely and fundamentally is due to the fact that the Web
has accelerated the flow of information on a global scale.

Granted that machines might not be able to mine this web of OME sites
initially, in the long term data would naturally be refined and micro
ontologies could be developed to help machines cope with unstructured
data, just like it happened for the Web. In the short term, leveraging
the existing OME ontology would already go a long way!


Discussion Kick-off
-------------------
I would like to explore the idea of a web of OME's. It would be a distributed
information space of interlinked resources based on the model of the World Wide
Web. Potentially any piece of information as identified by the OME data model
could count as a resource and it should be possible to create links among any
number of resources, possibly even references to data external to OME.
Each resource would have a global identifier and could be manipulated in a
uniform way using "CRUD" methods. A resource could have many representations
(e.g. a raw image or JPEG, an ROI represented in different coordinate systems,
JSON or XML formats, etc.) and clients would be able to select which one to
retrieve.

How to implement such a thing? One obvious answer would be to embed this
information space in the Web itself in order to leverage both existing Web
and OME technology: Front-end RESTful Web services could provide access to
back-end OMERO servers. Of course other architectures are possible and can
be explored as well. Ideally we should not get bogged down with a purely
technical discussion, but rather collect different ideas, views and opinions
as well as exploring potential, challenges and opportunities.
