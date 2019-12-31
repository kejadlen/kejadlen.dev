---
title: '#beachconf'
...

At Pivotal Labs, when we're in between projects, we call it being on the
"beach". (I've heard other consultancies call it the "bench", which makes more
sense to me.) While this may sound like a dream for a lot of people, we've
found that most people get bored/burned out on beach after a few weeks. In
light of that, and to keep me more accountable, I've decided to start keeping a
log of what I'm doing on the beach.

### July 5

- [What's New in Foundation][212] (WWDC)
  - This wasn't too informative; some nice improvements with Objective-C
    interop with `String`/`Range` and copy-on-write, but I don't use key paths
    or KVO a lot, so that was not as interesting. The addition of
    [Codable][codable] is greatly welcomed, though.
- [A Mathematician's Lament][lament] (paper)
  - While I agree pretty much completely with the overall point, I did think it
    was overly harsh on math teachers.
- [Building Apps with Dynamic Type][245] (WWDC)
  - I've always been impressed by Apple's accessibility support as a developer
    (I do use a handful of accessibility features on iOS, but not Dynamic
    Type), and it's cool to see Apple steadily improving in this area.
  - Both designers and devs are going to have to adjust to constraints based on
    baselines instead of the space between labels.
- Poked around at [my implementation][kilo-rs] of [Build Your Own Text
  Editor][text-editor].

[212]: https://developer.apple.com/videos/play/wwdc17/212
[codable]: https://developer.apple.com/documentation/swift/codable
[lament]: https://www.maa.org/sites/default/files/pdf/devlin/LockhartsLament.pdf
[245]: https://developer.apple.com/videos/play/wwdc2017/245
[kilo-rs]: https://github.com/kejadlen/kilo-rs
[text-editor]: http://viewsourcecode.org/snaptoken/kilo/index.html

### July 6

- Poked around a bit more with [kilo.rs][kilo-rs]. Realized that I need to
  handle `STDIN` differently, so I'm going to let that simmer in my
  subconscious for a bit before continuing.
- [Life After Nil][life-after-nil] (video)
  - Mostly skimmed through this talk about applying concepts learned from
    Haskell to Ruby. Not much new to me here, but validating to see that I've
    reached similar conclusions as other people.
- [Auto Layout Techniques in Interface Builder][412] (WWDC)
  - Learned a few neat tricks in this talk. I like how hard Apple's pushing
    Dynamic Type across their WWDC presentations. From my anecdotal experience,
    I've seen a number of people on the bus using that accessibility feature.
- Wrote [a blog post on encrypting stuff in git][encrypting-stuff-in-git].
- [Can Programming Be Liberated from the von Neumann Style? A Functional Style
  and Its Algebra of Programs][backus-turing] (paper)
  - Basically Backus complaining about "von Neumann style" programming
    languages.  Interesting how not much seems to have changed in this regard
    since he wrote this in 1978.
- [An Experiment in Software Prototyping Productivity][haskell-prototype]
  (paper)
  - Some interesting findings, even keeping in mind the authorial bias for
    Haskell.

[life-after-nil]: https://vimeo.com/200077718
[412]: https://developer.apple.com/videos/play/wwdc2017/412/
[encrypting-stuff-in-git]: {{ site.baseurl }}{% post_url 2017-07-06-encrypting-stuff-in-git %}
[backus-turing]: http://www.thocp.net/biographies/papers/backus_turingaward_lecture.pdf
[haskell-prototype]: http://haskell.cs.yale.edu/?post_type=publication&p=366

### July 10

- [Haskell taketh away: limiting side effects for parallel
  programming][haskell-taketh-away] (video)
  - GHC's intermediate language (System FC) has just 3 types and 15
    constructors!
  - Learned about [Safe Haskell][safe-haskell].
  - Not imperative vs. functional - really about determinism vs.
    non-determinism.
  - In-place parallel sorting inside of a pure function.
  - Didn't know that Haskell is still actively evolving.
- Bartosz Milewski's [Category Theory for
  Programmers][category-theory-for-programmers] (book)
  - > [T]esting is almost always a probabilistic rather than a deterministic
    process. Testing is a poor substitute for proof.
  - The bottom type makes sense to me now on this re-read.
  - This is starting to realize some of the subjects from prior book clubs:
    operational and denotational semantics were covered in [Understanding
    Computation][understanding-computation].
  - > The initial object is the object that has one and only one morphism going
    to any object in the category.
  - *poset*: partially ordered set
  - `Void` is different from `()`
  - > The terminal object is the object with one and only one morphism coming
    to it from any object in the category.
  - > There is the propositional equality, intensional equality, extensional
    equality, and equality as a path in homotopy type theory. And then there
    are the weaker notions of isomorphism, and even weaker of equivalence.
- [What's New in Signing for Xcode and Xcode Server][xcode-signing]
  - Figured I should watch this, given how much trouble code signing gave us on
    my last project.

[haskell-taketh-away]: https://www.youtube.com/watch?v=lC5UWG5N8oY
[safe-haskell]: https://wiki.haskell.org/Safe_Haskell
[category-theory-for-programmers]: https://bartoszmilewski.com/2014/10/28/category-theory-for-programmers-the-preface/
[understanding-computation]: https://www.amazon.com/Understanding-Computation-Machines-Impossible-Programs/dp/1449329276/
[xcode-signing]: https://developer.apple.com/videos/play/wwdc2017/403/

### July 11

- [Simple Algebraic Data Types][adts] in [Category Theory for
  Programmers][category-theory-for-programmers] (book)
  - So I've tried reading this book in the past and have gotten past here, but
    this is feeling much more understandable now that I've watched some of
    [Bartosz's lectures on category theory][category-theory-youtube] and read
    Eugenia Cheng's [How to Bake Pi][bake-pi].
- `present.rb` (project)
  - I was volunteered to do a talk on [Pry][pry] for work, so I have started
    yak shaving by writing a presentation tool that meets my personal
    requirements. More on this in a later post.
- Tutoring at [Ada Developers Academy][ada]
  - The current cohort is working on capstones now, so there was an impressive
    breadth of technologies that I helped out with:
    - Getting a Parrot drone onto a WiFi network
    - Connecting to Intuit using an npm library
    - Redacting private information that was pushed to GitHub
    - Using Postgres with SQLAlchemy and Alembic
  - It's always fascinating to me that I'm still able to contribute despite not
    being an expert on many of the above areas. In the end, being exposed to
    similar issues and troubleshooting is a skill that's broadly applicable
    across all of these different problems.

[adts]: https://bartoszmilewski.com/2015/01/13/simple-algebraic-data-types/
[category-theory-youtube]: https://www.youtube.com/playlist?list=PLbgaMIhjbmEnaH_LTkxLI7FMa2HsnawM_
[bake-pi]: http://eugeniacheng.com/math/books/
[pry]: http://pryrepl.org/
[ada]: http://adadevelopersacademy.org/

### July 12

- [Debugging with Xcode 9][debugging-with-xcode]
  - Yay for wireless debugging and view controllers in Xcode's view hierarchy,
    although there was a bunch of stuff on SpriteKit and SceneKit that I'm not
    really interested in.
- Pry presentation
  - Finished the MVP for both the presentation tooling and the presentation
    itself. With those now done, I have a better idea of how to approach the
    problem "for real", as it were.
- [Compiling C to printable x86, to make an executable research
  paper][c-to-x86] (video)
  - A great video explanation of making an x86 compiler that creates printable
    executables. Entertaining and educational.

[debugging-with-xcode]: https://developer.apple.com/videos/play/wwdc2017/404/
[c-to-x86]: https://www.cs.cmu.edu/~tom7/abc/

### July 13

- Facilitated an inception for a new project.

### July 14

- [praesent][praesent]
  - Played around with making this more robust and less of a one-off
    experiment. Thought about making it more generic or using a Ruby DSL, but
    in the end, I don't really need that additional complexity and would rather
    keep it as simple as I can.

[praesent]: https://github.com/kejadlen/kejadlen.github.io/tree/master/presentations
