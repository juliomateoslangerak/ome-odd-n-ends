A reactive architecture for image data management
=================================================

Author Line
-----------
> Andrea Falconi, Julio Mateos-Langerak, Volker Baecker, Olivier Miquel, 
> Geneviève Conejero, Edouard Bertrand

Affiliation
-----------
> Montpellier Ressources Imagerie - Biocampus
> 141 rue de la Cardonille, Montpellier, France
> [www.mri.cnrs.fr](http://www.mri.cnrs.fr)

Abstract
--------
We have extended the Open Microscopy Environment (OME) software suite with
a Web application to import images into OMERO. This new server application
exposes a REST API that allows any Web client to asynchronously trigger
image imports into any OMERO repository available on the network. Imports
are run on behalf of OMERO users but outside of their login sessions which
allows a user to log on an acquisition workstation, trigger the import and
then immediately log out without having to wait for the image data being
transferred out of the workstation into the OMERO repository. Thus, the
workstation (and the microscope) becomes immediately available to the next
user. Moreover, if users are billed for the time that they are logged on an
acquisition workstation, this new server application avoids the user paying
for the time that it takes to transfer their image data into OMERO.

The application is grounded on a reactive architecture designed with
scalability and resilience in mind in order to cope effectively with large
data volumes and workloads. This Web-based, message-driven design is generic
enough to be used for other data transfer (e.g. FTP) or OMERO-related tasks,
to integrate heterogeneous applications, or as the basis for a task server.

Repo
----
All our work, from design blueprints to source code, is open-source and
freely available on GitHub:

* [Code](https://github.com/c0c0n3/ome-smuggler) 
* [Docs](http://c0c0n3.github.io/ome-smuggler)

Challenges
----------
* stay responsive without interferring with running acquisitions
* reliably import large data sets
* overcome transient failures
* provide back-pressure mechanism to avoid OMERO overload
* ensure outcome notifications
* scale horizontally to dozens of machines

OME
---
software suite, an open-source platform for the storage, transfer, management,
visualisation, analysis, sharing and publication of image data and metadata.

From image acquisition to publication, OME provides the infrastructure needed
to manage the entire process in an automated, secure, and reliable fashion,
catering for the storage, transfer, management, visualisation, analysis,
sharing and publication of image data and metadata.

- [www.openmicroscopy.org](http://www.openmicroscopy.org/)
