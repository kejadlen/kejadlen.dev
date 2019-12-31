---
title: Blog upgrade!
...

With [Webby](http://webby.rubyforge.org/) being [deprecated](https://groups.google.com/forum/?fromgroups#!topic/webby-forum/QTYsgsY_UnY%5B1-25%5D), I intended on moving this blog over to [Jekyll](https://github.com/mojombo/jekyll/), as it's supported natively by [GitHub Pages](http://pages.github.com/). This would have allowed me to use a single repository for this blog, instead of having one repo for the source and a second which would hold the "build" that would be hosted by GitHub.

Unfortunately, I quickly bumped up against Jekyll's limitations, mainly due to the [Liquid](http://liquidmarkup.org/) templating language that Jekyll uses. To accomplish what I wanted to do, I would need to add my own [plugins to Jekyll/Liquid](https://github.com/mojombo/jekyll/wiki/Plugins). This more or less defeats the original choice of Jekyll, as I wouldn't be able to use a single repository. And once that became obvious, I figured I may as well evaluate other static site generators.

Some research on Google quickly revealed two main candidates that appealed to me: [Middleman](http://middlemanapp.com/) and [nanoc](http://nanoc.stoneship.org/). After fiddling around with a test blog and some sample posts in both, I settled on nanoc. Middleman felt more powerful, but I preferred the simplicity of nanoc. (Perhaps because it's more like Webby, which is what I was familiar with.)

As I was upgrading the "backend", I also wanted to pretty up the frontend a bit. Not the smartest decision, as I was now also investigating HTML/CSS frameworks alongside the static site generators. But since I know far less about the former, I chose [Foundation](http://foundation.zurb.com/), mostly since it allows for a [semantic grid](http://foundation.zurb.com/docs/gem-install.php#mixins) using [Compass](http://compass-style.org/). (Although I knew I didn't want to use [Bootstrap](http://twitter.github.com/bootstrap/) since it's so prevalent across the web.)

And finally, here's the end result of all that work! It didn't take me [one day](http://erjjones.github.com/blog/How-I-built-my-blog-in-one-day/), but it was rather satisfying nonetheless. The hardest part was getting everything to work together, and figuring out how nano's [rules](http://nanoc.stoneship.org/docs/4-basic-concepts/#rules) worked, but as usual, most of the answers were just a Google search away.

One last note: if you do have to use two repositories for hosting a site on GitHub, I highly recommend using a [submodule](http://git-scm.com/book/en/Git-Tools-Submodules) for the build. For this blog, I added the GitHub Pages repo ([kejadlen.github.com](https://github.com/kejadlen/kejadlen.github.com)) as a subdirectory of the main repo ([kejadlen.net](https://github.com/kejadlen/kejadlen.net)) so that I could build the site straight into the build repo. (Or you could add a rake task to dump the output dir into the build repo. Either works, but I find this more convenient.)

The source for this blog is available on GitHub [here](https://github.com/kejadlen/kejadlen.net).
