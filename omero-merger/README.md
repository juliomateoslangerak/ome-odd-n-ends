Smuggler/OMERO Merger Proposal
==============================

As part of developing a solution for background OMERO imports, we've also
developed a great deal of general-purpose messaging infrastructure that we
could now easily leverage to bring async messaging into OMERO and with it,
some of the benefits of a [reactive architecture][reactive], such as 
scalability and fault-tolerance. You guys need something similar for IDR
and will have to sort out OMERO import performance sooner or later---the
(in-)famous Luke's straw, which BTW has bitten us hard at MRI too! So maybe
it's time to bite the bullet.

MRI can cough up enough to cover another full year of development where I
could work on bringing messaging into OMERO and tackle import performance.
This would be 100% OMERO development, i.e. I won't have to develop stuff
for MRI. (In fact, sadly we'll have to leave behind other interesting MRI
projects like OMERO metrics!) But there's a catch, obviously. MRI are going
to fund us as long as at the end of this chunk of development Smuggler's
core functionality is fully integrated into OMERO and eventually available
in future OMERO releases. Which would be a good thing if it wasn't for
the fact I'll have to leave MRI past that year and you guys will have
to maintain the code.

Anyhoo, out of the whole Smuggler's codebase, approx 2500 lines of code
account for OMERO background import functionality, the rest is modular,
general-purpose code that like I said we could readily reuse in OMERO.
Even if no other imaging facility out there (besides MRI) needed background
imports (which I doubt!), the maintenance burden on you guys would be
negligible, also taking into account that

* Smuggler's well documented ([docs site][docs-site], [JavaDoc][javadoc]]),
tested ([Codecov][codecov]), and comes with a fully automated build/test/release
cycle ([Travis CI][travis]).
* We could use background imports to enable imports in the Web client,
at which point you could probably ditch Insight and the maintenance
burden that comes with it!

I've detailed in a separate [Use Cases][use-cases] page exactly what
functionality we'd need to keep in a hypothetical OMERO/Smuggler merger
scenario and have put together a [Codebase Breakdown][code-breakdown] to
help you guys gauge what you're getting yourselves into :-) I've also
got the beginning of a [technical proposal for a merger][tech-details] but
we'll need to work on it together cos I need more input from you guys.




[codecov]: https://codecov.io/gh/c0c0n3/ome-smuggler
    "Smuggler on Codecov"
[code-breakdown]: code-breakdown.md
    "Codebase Breakdown"
[docs-site]: http://c0c0n3.github.io/ome-smuggler/
    "Smuggler's Docs"
[javadoc]: http://c0c0n3.github.io/ome-smuggler/docs/content/javadoc.html
    "Smuggler's JavaDoc"
[reactive]: http://www.reactivemanifesto.org/
    "Reactive Manifesto"
[tech-details]: tech-details.md
    "Technical Details"
[travis]: https://travis-ci.org/c0c0n3/ome-smuggler
    "Smuggler on Travis CI"
[use-cases]: use-cases.md
    "Use Cases"
