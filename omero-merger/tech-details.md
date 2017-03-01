Technical Details
=================

Like I said OMERO imports only make up approx a quarter of Smuggler's
codebase, whereas the rest is sort of generic and we can leverage it
to easily bring async messaging into OMERO. In fact, Smuggler's core
is made up of

* a generic, strongly-typed messaging API with pluggable backing queueing
system (MOM);
* a run/retry/notify infrastructure built on top of it to schedule and
execute tasks;
* a REST front-end to expose this functionality.

If you need to find out more about this, you can read about Smuggler's
architecture [over here][high-view] and about messaging in particular
[here][messaging].

We could probably put all this to good use fairly soon in e.g. IDR even
before integrating it tightly into the OMERO mainline. For example, I
could easily add a Web service IDR could use to queue and execute tasks.
This would work pretty much like an OMERO import: you POST the task and
get back a URL you can poll to get that task's output. (Each task runs
in a separate process with its stdout redirected to the poll URL.)
I've got NixOS images for cloud deployment, but could do Ansible going
forward. Either way, dumping a Smuggler instance in your IDR cloud shouldn't
be too hard. So you could have a queueing system in IDR fairly soon.

Now Smuggler runs with an embedded HornetQ but I can easily strip it out to
build a distributed queue. The next step could be that we replace HornetQ
with a MOM of your choice. Smuggler supports plugging in a different MOM
backend, but I'll obviously have to write the glue code for e.g. Redis +
whatever you'd like to use.

All in all it shouldn't be to hard to turn Smuggler into a generic Web
queue with a MOM of your choice. Also, Smuggler comes with an OMERO session
keep-alive service that comes in handy for running queued tasks---think this
was on Luke Hammond's and (many others) wish list. But I'd take it a step
further and develop a proper token system for long running OMERO tasks.

What next?

+ web import?
+ import performance. I've written up some notes about ways to deal with
a large import object graph outside of a single big honking transaction while
still ensuring eventual data consistency...Going to look for my notes and
add it here...
+ what else? think all the above is already way more than a man-year worth
of development?!

### Notes
Sometimes I have wild dreams of an OMERO distributed file system to sort
out once for all: Luke's straw, data import/export, security, federated
repos. But when I wake up I realise this is madness. Anyhoo, I've collected
my brain farts [over here][crazy].




[crazy]: crazy-ideas.md
    "Crazy Ideas"
[high-view]: http://c0c0n3.github.io/ome-smuggler/docs/content/design/high-level/index.html
    "High-level View"
[messaging]: http://c0c0n3.github.io/ome-smuggler/docs/content/design/messaging/index.html
    "Messaging"

