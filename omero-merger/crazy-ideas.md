Crazy Ideas
===========

Forgot to mention I've been thinking about implementing an OMERO distributed
file system. On the one hand I think this is madness and a total waste of
time. On the other hand, every large scale OMERO deployment ends up rolling
out their own ad-hoc solution. Also we want federated repos. Oh, then we
have Luke's straw. Speak of the devil, I've collected below some of the
points from [his presentation][luke] I think are relevant here:

* Need to be able to preview image data before accessing it
* Data preservation when researchers leave lab
* Prevent unnecessary duplication of image data
* Support for large scale images. An exporter client similar to the importer
could help to manage this problem and allow the appropriate download procedures
to occur in the background. Can we avoid the Blitz gateway? Appears to constrain
the handling of binary data and it is assumed that this is where most of the
problems in image processing lie
* Requires a solution that is built to scale and can drive up hardware
utilisation
* A simple and unhindered means of transferring data in and out of OMERO for
external processing (e.g. GPU-cluster analysis) One possibility: A direct FTP
access API similar to the OMERO Importer to enable queued uploading to OMERO
with appropriate permissions and relationships (as these would be large image
files, preferably avoiding the restrictions of the ICE framework).

My thinking here is that something like IPFS with built-in OMERO security
would fit the bill and also enable federated repos? Also you guys have
accumulated a huge amount of knowledge about imaging formats we could put
to good use to fine tune a file system dedicated to images only---e.g.
indexing, self-tuning depending on how programs access planes/ROIs, etc.
Also, if we assume image data is read-only, things are much simpler (think
e.g. cache consistency protocols) and there's heaps to gain when it comes
to performance---the initial design of GFS springs to mind...

I know all this sounds crazy, but for some reason I can't help thinking
about it...




[luke]: http://downloads.openmicroscopy.org/presentations/2016/Users-Meeting/Talks/LukeHammond_OME_2016.pdf
    "Alone in the dark making big data"
