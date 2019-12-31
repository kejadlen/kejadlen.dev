---
title: Hpricot is awesome
...

So I have to admit that after watching some [Kitchen 4B](http://video.nytimes.com/video/2009/04/18/magazine/1194839633989/pizza-at-home.html,) I developed a bit of a crush on Jill Santopietro. Unfortunately, [The Moment](http://themoment.blogs.nytimes.com/) only has a single RSS feed for the entire blog, and this includes a bunch of content I'm not particularly interested in. But with some quick Hpricot magic, I quickly whipped up a script to use in NetNewsWire. (Also, much love for NetNewsWire enabling me to create subscriptions to scripts such as these.)

```ruby
require 'rubygems' # Since I"m too lazy to set the RUBYOPTS
                   # environment variable for NetNewsWire

require 'hpricot'
require 'open-uri'

doc = Hpricot.XML(open('http://themoment.blogs.nytimes.com/feed/atom/'))

(doc/:entry).reject {|entry| (entry/:author/:name).inner_text =~ /Jill Santopietro/ }.remove

puts doc.to_html
```

**Edit:** I've since replaced this script with [a Yahoo Pipe](http://pipes.yahoo.com/kejadlen/58c7c48b0198b276d2a98c11e08179b5), as this allows me to view this feed in both Google Reader and NetNewsWire.
