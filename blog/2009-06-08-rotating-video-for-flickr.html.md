---
title: Rotating video for Flickr
...

Much thanks to these [blog](http://blech.vox.com/library/post/rotate_video_for_flickr.html) [posts](http://www.hanselman.com/blog/HowToRotateAnAVIOrMPEGFileTakenInPortrait.aspx) for revealing the secrets behind rotating video with mencoder. Specifically, I had taken video on my D90 which needed to be rotated into portrait.

```console
mencoder -vf rotate=3,scale=405:720 -o middle.avi -oac copy -fafmttag 1 -ovc lavc -lavcopts vcodec=mjpeg input.avi
mencoder -vf expand=960:720 -oac copy -ovc lavc -lavcopts vcodec=mjpeg middle.avi -o output.avi
```
