---
title: Postfix to infix, part 2
...

After seeing Christian von Kleist’s solution, I couldn’t help but play with it a bit to come up with this:

```ruby
puts ARGV[0].split(/\s*/).inject([]) {|n,i|
  n << ((%w[+ - * /].include?(i)) ? (b,a=n.pop,n.pop; "(#{a} #{i} #{b})") : i)
}[0]
```
