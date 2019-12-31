---
title: Using Python (sanely) on OS X
...

Because I always forget, this is for my future self:

```console
$ sudo easy_install pip # install pip
$ sudo pip install virtualenv # install virtualenv
$ virtualenv DIR # set up virtualenv
$ source bin/activate # activate virtualenv
```

I think this is the cleanest way of using Python on OS X, short of installing a new version of Python via [Homebrew](http://mxcl.github.com/homebrew/). (For Ruby, I like to use [rbenv](https://github.com/sstephenson/rbenv) and [ruby-build](https://github.com/sstephenson/ruby-build), since it's handy to be able to use both 1.8 and 1.9 versions for my personal work.)
