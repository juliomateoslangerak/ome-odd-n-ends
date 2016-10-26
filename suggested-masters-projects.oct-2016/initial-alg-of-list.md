Mathematics has proved invaluable in computer science. Its use is pervasive
in so many fields of computing (e.g. theoretical computer science, AI, etc.) 
that many scientists rightly regard computer science as a branch of applied 
mathematics. Indeed, if you believe Dijkstra, *"programming is one of the most
difficult branches of applied mathematics"*.

Mathematical constructions are latent in every requirement we analyse, every
design we devise, every line of code we write, and every test we craft. 

As an example, take the ubiquitous task of processing a sequence of data 
items---a list, an array, a database result set, etc. How can it be done
"mathematically"?

First, consider this (real) polynomial

    p(t) = 1 + a×t          (a ≠ 1)

We can think of it as a recipe to build a number out of an input `t`. The
recipe says: take the number `1`, take the number obtained by multiplying
`a` by `t`, then sum these two. In pictures

         *             a,t
    take |              | multiply
         |       +      |
         ▼              ▼
         1∈ℝ          a×t∈ℝ

We ask: is there any input `l` that the above recipe `p` gives back as output,
i.e. `p(l) = l`? (Any such value is called a fixed point of `p`.) To find the
answer we can simply solve

    1 + a×t = t

which gives `t = 1/1-a`. That's our `l` then, so that

    1 + a×l = l

This says that `l` is made up of a sum and a product. It turns out we can use
the same recipe for sets or types instead of numbers. In fact, consider the
same polynomial

    P(T) = 1 + A×T

but let `T` vary over sets, `A` be a given set and `1` the one-element set 
`{*}`; then take disjoint union of sets for sum and Cartesian product for 
multiplication.

* * *
- **TODO**. Shaw! Long and sloppy argument. Not even that intuitive, IMHO.
To complete it, I should try to introduce P's fixed point and then show how
that leads to recursion. Really? Come up with a better way for an informal 
introduction to initial algebras, polynomial functors, etc.
* * *

This point of view leads to very general, concise, and elegant programs.

If this is something you may be interested in, we will assist you in applying 
this "algebraic" approach to your project. As part of your project, you will 
be exposed to abstract algebra (e.g. monoids, groupoids, vector spaces, and 
perhaps some category theory) and functional programming (quite possibly in 
Haskell) as a means to specify, construct, transform, verify and reason about
programs. We require no prior experience in abstract algebra or in functional
programming and will provide suitable training as needed.

However, bear in mind that this is entirely up to you. If you would rather 
use more traditional, mainstream programming techniques, you are more than
welcome to.
