---
title: Using uShare to stream video from Ubuntu to an Xbox 360
---

With much thanks to [this blog post](http://www.virtual-sushi.co.uk/blog/how-to-stream-videos-from-ubuntu-to-xbox360-with-ushare/), which reveals how to fix `/etc/ushare.conf` and `/etc/init.d/ushare`.

Install the dependencies:

```console
$ sudo apt-get install libupnp-dev pkg-config
$ sudo echo "deb http://www.geexbox.org/debian/ unstable main" >> /etc/apt/sources.list
$ sudo apt-get install libdlna-dev ushare
```

(uShare’s being installed here just to grab the conf files.)

Pick up the latest version of uShare (assuming Mercurial is installed):

```console
$ hg clone http://hg.geexbox.org/ushare
```

In the uShare directory:

```console
$ ./configure --prefix=/usr/local
$ make
$ sudo make install
```

Now the configuration files need to be edited. Make the appropriate changes to `/etc/ushare.conf`, making sure to modify `ENABLE_XBOX` to `USHARE_ENABLE_XBOX`. The rest should be self-explanatory.

In `/etc/init.d/ushare`, add `USHARE_OPTIONS="-f $CONFIGFILE"` so that the correct command line is sent to uShare.

And now you should be able to stream videos from your Ubuntu fileserver to your Xbox 360.
