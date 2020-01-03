---
title: Generating animated GIFs using RMagick
---

Sample code:

```ruby
anim = Magick::ImageList.new(*Dir["/some/path/*.jpg"])
anim.each {|img| img.resize!(200,200) }
anim.delay = 10
anim.unshift Magick::Image.read("/some/image.jpg")[0].resize(200,200)
anim << Magick::Image.read("/some/other/image.jpg")[0].resize(200,200)
anim.write("animated.gif")
```

Example image:
{% include img name="gloria.gif" %}
