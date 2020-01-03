---
title: Playing with RubyOSA and iTunes
---

I wanted to create a playlist based off played count versus skipped count, so some playing around with [RubyOSA](http://rubyosa.rubyforge.org/) was warranted. Unfortunately, although the iPod updates iTunes with the play count of songs, it doesn’t do so for the skipped count! I am sorely disappointed.

``` ruby
require 'rbosa'

itunes = OSA.app('iTunes')

music = itunes.current_playlist
music.name  #=> "Music"
tracks = music.tracks

sum = tracks.inject(0) {|n,i| n + i.played_count }  #=> 3871
average = sum / tracks.size.to_f  #=> 3.61100746268657

std_dev = (tracks.map {|t| (t.played_count - average)**2 }.inject(0) {|n,i| n + i } / tracks.size.to_f)**0.5  #=> 5.63593796507849
```

Caveat: I couldn’t figure out how to grab a specific playlist, so this snippet of code only works on the current playlist.
