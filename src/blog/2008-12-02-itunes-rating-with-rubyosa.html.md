---
title: iTunes ratings with RubyOSA
---

Rating songs is a pain. Since iTunes keeps track of played and skipped counts, I thought I could use those to create new ratings.

In actuality, I was too lazy to analyze the data with a stat package, so I opted for something a little simpler. I decided to use `played / (played + skipped)` as a metric and add a string to the comments field of the song if it met a threshold for that calculation.

```ruby
require 'rbosa'

OSA.utf8_strings = true
itunes = OSA.app('iTunes')
library = itunes.sources.find {|source| source.name == 'Library' }.playlists[0].tracks

library.each do |track|
  count = (track.played_count + track.skipped_count).to_f
  stat = track.played_count / count
  comment = track.comment
  if count > 5 and stat > 0.95 and track.video_kind == OSA::ITunes::EVDK::NONE
    comment << "\n" unless track.comment.empty?
    comment << "AlphaRating: 5"
    track.comment = comment
  elsif track.comment =~ /AlphaRating: 5/
    comment.sub!(/\n?AlphaRating: 5/, "")
    track.comment = comment
  end
end
```
