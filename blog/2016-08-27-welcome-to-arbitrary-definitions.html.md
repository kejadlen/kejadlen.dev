---
title: Welcome to Arbitrary Definitions!
...

It's been a while since I've had a website, so I buckled down this past week
and threw [this][kejadlen.github.io] together.

[GitHub Pages] was an obvious choice for the backend, seeing as how it's a)
free and b) simple (for me, at least). While I used [nanoc] for building [my
previous blog][kejadlen.net], I decided to go down the path of least resistance
this time and use [Jekyll with github-pages].

Despite mostly going with the flow on infrastructure, I can't help do some
things my own way. Last time, I went with [Zurb Foundation] over [Bootstrap]
(for really no good reason other than I like trying out less-popular options).
This time, I'm attempting to build mostly from-scratch on top of a few
lighter-weight libraries: [normalize.css], [Bourbon], and [Neat].

Since I'm no designer, I'm leaning on [Ethan Schoonover]'s [Solarized] and
taking some inspiration from [Tufte CSS] for the design. But mostly, I'm just
trying to avoid shooting myself in the foot in this area by keeping it simple.

## So is there anything interesting about how this blog is built?

Are you looking for something a little out of the ordinary? Well, I suppose
that how I'm doing dependency management for the CSS libraries is not normal.
Instead of downloading the files directly or using a binary delivered via
a dependency manager to install and update the library (which is a pet peeve of
mine, but I'll leave that rant for a future post), I've [vendored][vendor] the
dependencies using [`git` submodules][git-submodule] and [symlinked][symlink]
the libraries into the [`_sass` directory][sass].

This might seem like overkill, but I don't want to introduce additional tooling
unless absolutely necessary and as already mentioned, I hate installing tools
via dependency managers. Submodules make updating from upstream trivial (`git
submodule update --recursive`) and symlinks mean that if I need to make my own
changes (which shouldn't be necessary for this project), I don't need to jump
through hoops and can just update the files directly and then commit/push from
the submodule.

Although many people seem to shy away from `git` submodules, I find that it's
a powerful tool that I turn to surprisingly often. While it is easy to really
screw yourself over, a few ground rules and discipline make it quite rare.
Admittedly, `git` is a tool that I've sharpened over the years, so I'm quite
comfortable with it's edges, but it's a tool that's well worth honing.

[kejadlen.github.io]: https://github.com/kejadlen/kejadlen.github.io
[GitHub Pages]: https://pages.github.com/
[nanoc]: http://nanoc.ws/
[kejadlen.net]: https://github.com/kejadlen/kejadlen.net
[Jekyll with github-pages]: https://jekyllrb.com/docs/github-pages/
[Zurb Foundation]: http://foundation.zurb.com/
[Bootstrap]: http://getbootstrap.com/
[normalize.css]: https://necolas.github.io/normalize.css/
[Bourbon]: http://bourbon.io/
[Neat]: http://neat.bourbon.io/
[Ethan Schoonover]: http://ethanschoonover.com/
[Solarized]: http://ethanschoonover.com/solarized
[Tufte CSS]: https://edwardtufte.github.io/tufte-css/
[vendor]: https://github.com/kejadlen/kejadlen.github.io/tree/master/vendor
[git-submodule]: https://git-scm.com/docs/git-submodule
[symlink]: https://en.wikipedia.org/wiki/Symbolic_link#POSIX_and_Unix-like_operating_systems
[sass]: https://github.com/kejadlen/kejadlen.github.io/tree/master/_sass
