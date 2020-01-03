---
title: How to shut irb up
---

From [ruby-talk](http://groups.google.com/group/comp.lang.ruby/browse_thread/thread/9c1febbe05513dc0/b9d4686b270e4f50), how to shut irb up:

### .irbrc

```ruby
IRB.conf[:PROMPT][ IRB.conf[:PROMPT_MODE] ][:RETURN]='' 
```

Now irb won’t display the return value of the entered statement! Wonderful!

However, this does break [Wirble](http://pablotron.org/software/wirble/)’s colorize, as Wirble can’t colorize what doesn’t get displayed. But I can make a function called `pc` (for `p color`) which uses Wirble’s colorizing algorithm:

```ruby
require 'wirble'

def pc(*ary)
  ary.each do |obj|
    puts Wirble::Colorize.colorize(obj.inspect)
  end
end
```

**Edit**: Fixed pc to work with multiple arguments.
