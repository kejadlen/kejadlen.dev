---
title: Using cmd.exe's "start" in Cygwin
...

So one of the niceties about OS X is the integration with the terminal. I’ve already [added pbcopy and pbpaste to Cygwin](/2007/02/24/pbpaste-and-pbcopy-in-windows), so I figured it was about time to get the `open` command working. Note that `cmd.exe` has a handy start command which is similar to `open` on OS X. (Not quite as nice, but hey, you take what you can get.)

Some quick Googling revealed [this page](http://generally.wordpress.com/2006/11/10/windows-hack-open-an-explorer-from-the-command-line/), and voila! A `start` which allows opening explorer windows (and files associated with programs) from Cygwin.

Just add `alias start="cmd /c start"` in the `if $cygwin; then block` of your `.bash_profile`.

(As an aside, I really should start putting these configs under source control.)
