Internship Proposal
===================
[Montpellier RIO Imaging][mri] is offering a software engineering internship 
for the development of components to extend the [Open Microscopy Environment]
[ome] (OME) software suite, an open-source platform for the storage, transfer,
management, visualisation, analysis, sharing and publication of image data 
and metadata. The internship is open to master's students in informatics.


Proposed Project
----------------
### Microscope performance monitor
The aim of this project is to develop an application to monitor microscope
performance through the automated analysis of control images commonly produced
by most microscopes. The application will leverage existing OME technology 
to import image data and metadata into a database, run analysis routines, 
store analysis results and make them available to end users through a Web 
client.

Much of the work will revolve around the definition of an extensible ontology 
for microscope performance data and of an associated storage format. The
ontology will have to cater for data and metadata of control images acquired
using a number of biological imaging modalities (scanning confocal, wide-field,
spinning disk) and allow for new modalities to be added in the future. An 
investigation of OME-supported storage formats (relational, hierarchical) 
should be carried out to determine which one fits best and a data model
should be developed through which the ontology can be stored.

The application should comprise two subsystems: analysis and reporting. 
The former will be responsible for running standard analysis routines on
acquired control images and store analysis results, while the latter will
be fed those results to produce a number of reports in a Web user interface. 
Both subsystems will operate on the data model mentioned above.
A mock-up of the reporting user interface is available [here][mockup].


Extras
------
The intern is obviously free to use whichever approach to programming they 
prefer, e.g. object-oriented analysis and design, etc.
However, we routinely use abstract algebra and functional programming as a 
means to specify, construct, transform, verify and reason about programs.
So there is an opportunity for the intern to gain some exposure to these
techniques and use them in practice to engineer a real-world application.

As a simple example, consider an XOR gate, the image of your face in the 
mirror and the following business rule: a customer should not submit an 
order until they have entered a shipping address. What do all these things
have in common? One possible answer is that they all exhibit the same kind
of symmetry and this pattern is nicely captured by an algebraic model (the
[actions][actions] of the cyclic group of order 2).
Using an advanced functional programming language such as [Haskell][haskell],
these algebraic models can then be readily turned into working programs
that retain essential mathematical properties at the type-system level,
so that the programmer can reason mathematically about the code and the
compiler can verify program correctness.

If this approach to programming is appealing to the intern, we will provide
them with suitable training in order to be able to use algebraic modelling 
and functional programming in their work.


Contact Details
---------------
Interested candidates should contact:

    Julio Mateos Langerak

    Arnaud de Villeneuve Campus Imaging Facility
    Montpellier RIO Imaging
    Montpellier BIOCAMPUS, UMS3426
    Institut de Génétique Humaine-CNRS
    141, rue de la Cardonille
    F-34396 Montpellier (France)
    
    e-mail: Julio.Mateos-Langerak@igh.cnrs.fr
    phone: +33.4.34.35.99.90




[actions]: https://en.wikipedia.org/wiki/Group_action
    "Group action"
[haskell]: https://haskell-lang.org/
    "The Haskell programming language"
[ome]: http://www.openmicroscopy.org/
    "The Open Microscopy Environment"
[mockup]: https://github.com/c0c0n3/ome-odd-n-ends/blob/master/suggested-masters-projects.oct-2016/omero.metrics/reports.mockup.png
    "Microscope performance monitor - Reports UI mock-up"
[mri]: https://www.mri.cnrs.fr/
    "Montpellier RIO Imaging"
