OMERO.metrics: microscope performance analysis and reporting.
==============

**Currently**: Maintenance and performance tuning of microscopes involve the acquisition
of images under specified conditions and subsequent image analysis to extract key system
performance and status parameters---such as field homogeneity, resolution, laser power
and linearity, etc. The maintenance procedure is tedious and performance evaluation data
are not directly available to facility users.

**Idea**: Develop an OMERO add-on to collect standardized microscope performance images,
analyse them to evaluate system performance and status, manage analysis data and make them
available through reports.

* Platform engineer imports performance images according to a given protocol, defining
  ROI's in the process.
* OMERO detects imported images as performance images and runs associated analysis
  routines.
* Web client presents engineer and facility users with online reports including processed
  images along with microscope performance data plots showing how measurements change over
  time. Reports can be printed.

