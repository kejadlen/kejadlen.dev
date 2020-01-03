---
title: Flickbook on Shoes
---

Although using a server to sync pictures from Flickr to Facebook is by far easier to program, it is rather unwieldy when you want to actually use said tool. Even though I was the one who did the programming, getting it set up and running on the server was no fun at all. I thought this would be a fun excuse to play around with [Shoes](http://shoooes.net/.) (It also seemed an appropriate choice, as the previous Flickbook used [Camping](http://github.com/why/camping/tree/master.) Doing a native app using Obj-C and Cocoa also crossed my mind, but I didn't want to spend much time on the project, and decided to stick with my main language.)

Well, without further ado, [here's Flickbook v2](http://github.com/kejadlen/flickbook/tree/master.)

Some interesting bits:

* Flickbook: 115 LOC.
* Flickr API: 48 LOC.
* Facebook API: 73 LOC.

The interface is pedestrian, to say the least, but it does its job. Eventually, I'll have to figure out an elegant way to separate web authentication from desktop authentication in the two API libraries, but that's a job for another day.

