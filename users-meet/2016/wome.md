Web of Open Microscopy Environments (WOME?!)
===================================

- produce data to discover
- web made it obvious that sharing accelerates the building of new knowledge
- ome is open but not connected = inter-linked, e.g. reference data in other
  ome site.
- *lots* of *diverse* data, you'll need *both* humans and machines to mine
- potential, challenges, and opportunities
  - opportunity:
    crowdsource the finding of similarities in imaging data; might work cos
    lots of people are affected by diseases this kind of research studies,
    e.g. cancer.

Information Age
---------------
- Automated digital technologies allowed vast increases in the rapidity of
  information growth
- Though the Internet itself has existed since 1969, it was with the invention
  of the World Wide Web in 1989 that the Internet became an *easily accessible*
  network.
  The Internet is now a *global* platform for *accelerating* the *flow of information*

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
process (once performed by humans only!) of data aggregation, correlation, and
pattern discovery, resulting in new knowledge being produced at unprecedented
rates in many fields.
Perhaps, the most exciting aspect of "Big Data" is not that we are producing
oceans of bytes, but rather that there are potentially many interesting
relationships among diverse data sets which are yet to be discovered and
availability of these data sets for analysis makes discovery possible.
The key observation here is that aggregating data sources may lead to the
acquisition of new knowledge that would not have been possible to extract
from each individual data source in isolation.
(Darwin had to examine many diverse data sets to put together the pieces of
the evolution puzzle.)


Big Islands
-----------
Traditionally biologists who do imaging tend to work on their own data sets
in isolation, producing knowledge that is eventually published in a paper and
connections among different studies may only be realised much later down the
line by someone examining those studies. Even then, much could potentially
still remain undiscovered simply because all the relevant data supporting the
studies (images and analysis) are not available. Even though these individual
data sets may be large, they are not connected---just like islands in an ocean.

As increasingly more research institutions urge biologists to make available
the data supporting published studies, we have an opportunity to aggregate
data (images, measurements, results, etc.) from diverse sources and have
machines mine the aggregate to extract new knowledge with the potential to
accelerate the process of scientific discovery.
An alluring prospect, but certainly as challenging as alluring. While there
are many stumbling blocks (dealing efficiently with large amounts of data,
building conceptual bridges among very different imaging domains, coping with
unstructured or poorly annotated data, perturbations in the experimental data,
etc.) and probably no silver bullet, some progress can still be made.


Even "Bigger Data"
------------------
OME has undoubtedly proven its value as a data management and integration
platform, but also has the potential to deliver a solid foundation for mining
biological imaging data sets aggregated from different studies. A case in point
is the IDR project which aims to extract feature sets out of multiple studies
with the hope to deliver some measure of similarity in terms of image structure,
dynamics, and components.

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
would provide the means to accelerate the flow of scientific information
among imaging biologists with the potential to also speed up the pace at
which connections among studies are made. The importance of this should
not be underestimated. One example above all of
by accelerating the flow of information
on a global scale, the World Wide Web has forever changed our lives.



Granted that machines might not be able to mine this web of OME sites
initially, in the long term data would naturally be refined and micro
ontologies could be developed to help machines cope with unstructured
data, just like it happened for the Web.

Can we push OME's ability to aggregate and connect diverse data sets even
further?

The idea we would like to explore is that of a distributed information space of
interlinked resources based on the model of the World Wide Web. Any piece of
information as identified by the OME data model could potentially count as a
resource and it should be possible to create links among any number of
resources, possibly even references to data external to OME.

- how to compose two ome sites?
- linked data, REST
- event though we might not be able to mine it initially, there's still a lot of
  value in building a network of open, interlinked, and easily accessible resources.
- the web is living proof
- key factor: accelerate information flow

- example. how would i connect roi + measurements in site 1 to dataset + tags
  in site 2? If each site allowed us to identify these resources and ome had the
  ability to interlink data, then i could easily create my own site 3 where i
  make the connection by creating a link and possibly some metadata associated
  to it.


What does all this have to do with OME? Before answering that question...

- note:
  - imaging experiments traditionally done in isolation, no sharing
  - aggregation & mining of knowledge carried out by humans (read paper, make
    connection)
  - possibly many interesting relationships could emerge if data sets were
    brought together
- IDR great example of potential of OME tech to accelerate scientific discovery
  - make data available
  - aggregate
  - analysis
  - indeed IDR aims to extract feature sets out of multiple studies with the
    hope to deliver some measure of similarity in terms of image structure,
    dynamics, and components

Even "Bigger Data"
------------------
WOME
  - can we push all this even further?
  - Web good example of sharing, aggregation, etc. (*easy* both for programmers
    and non-programmers)
  -
