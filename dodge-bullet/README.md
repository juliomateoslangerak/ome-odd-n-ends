Dodging the Combinatorial Bullet
================================

Presentation I gave on 9 Jun 2017 at the OME interview about using simple
algebra to avoid the enumerate & classify trap I get caught in at times
when doing object-oriented design. Parking it here just in case I'll want
to reuse it for something else.

Each SVG file contains a slide---`1.svg` 1st slide, `2.svg` 2nd, etc. To
make it look like the SVG fills the whole browser window, I set document

* `height` and `width` to `100%`
* background colour to `style="background: #3c4747;"`

TODO
----
If reusing for another presentation, think about how to improve it. E.g.

- *Algebraic Model for Validation*. (Slide 6) I think it shouldn't take
more than a minute to explain to an audience who've had some exposure to
abstract algebra---e.g. linear algebra and/or group theory. But it could
easily take 20 minutes to explain in detail to programmers with no such
background. So only use this slide if you have enough time to explain or
your audience already know something about abstract algebra.
- *Conclusion*. Add a slide! Should at least mention that the algebraic
approach saves tons of dev time and reveals the hidden structure latent
in the initial problem.
- *Generalise*. In the context of a tech-talk there's no need to mention
the connection with projects I worked on. In that case, use your time to
talk about how the abstract non-sense relates to DSL's and in particular
EDSL's in a functional programming language. Also why not mention the
concept of an (algebraic) "executable" spec and program derivation.
- *Trivia*. Google apparently got the idea of map-reduce from functional
programming---Bird's work springs to mind, in particular the [homomorphism
lemma][homomorphism-lemma]. But algebraists knew a more general version
of this fact (UMP of free objects) at least half a century before and I
think the idea originated in the theory of vector spaces probably in the
19th century or earlier? (Check when exactly, just out of curiosity.)




[homomorphism-lemma]: https://en.wikipedia.org/wiki/Bird%E2%80%93Meertens_formalism#The_homomorphism_lemma_and_its_applications_to_parallel_implementations
  "The homomorphism lemma and its applications to parallel implementations"
