---
title: ruby-facebook
...

Wow. (Okay, not exactly “using”, but close enough.) Came upon [RBook](http://www.livelearncode.com/archives/14), another Facebook API library for Ruby. I think that makes three so far. This one apparently takes a few techniques out of my own [ruby-facebook](http://kejadlen.netherweb.com/ruby-facebook/doc) library, although I’m not quite sure what exactly.

However, I still really dig several things about my implementation that I haven’t seen in other ones (yet). One is how you get the query response back as a Hash. Making a call to `Message.GetCount` will return a hash with `total` and `unread` as keys. Currently, the values for each key are autoconverted into integers if possible, as I make the assumption that a string consisting of all numbers is meant to be an actual number.

Another nicety is that making API queries is a touch more natural (at least, in my opinion). Basically, the following calls are all valid (given that `f` is an instance of `Facebook::Session`):

```ruby
f.messages.get_count
f.messages.getCount
f.messages_get_count
f.messages_getCount
f.session_request("messages.getCount")
```

I happen to think that this is pretty nifty. The implementation is somewhat nastier, as I create another class to handle the subsequent message of `get_count` or `getCount`. I have a feeling that there’s a more elegant way to handle this, but I’m punting for now, as this works. (Possibly making an eigenclass from the current object that holds the request category? Hmm, it seems possible. Don’t know if it would be more elegant though.)

The last nifty bit from my implementation is that to add new API calls, all you need to do (theoretically) is to dump them into `Facebook::REQUESTS`, which is an Array that holds the valid API calls.

Not that there’s a right or wrong way to go about implementation and design, but those are just features of my library that I really dig.

But speaking of [ruby-facebook](http://kejadlen.netherweb.com/ruby-facebook/doc), it’s about time that I updated it to match Facebook’s updated API. I haven’t touched it since August, so hopefully I’ll find some time to fix it up later this week. Writing some test cases would probably be a good idea, but I really don’t want to muck with testing base_request, as that would require me to figure out how to fake the Facebook server. The other thing that I should do is figure out how to get rid of `MetaSession`, but honestly, I think doing so in an elegant way is going to require much more thought and work than I’m willing to put into the update.
