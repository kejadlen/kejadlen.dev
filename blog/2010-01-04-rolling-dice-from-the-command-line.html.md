---
title: Rolling dice from the command line
...

```ruby
puts eval(ARGV.join.gsub(/(\d+)d(\d+)/) {|s|
  rolls = $1.to_i.times.map { rand($2.to_i) + 1 }
  sum = rolls.inject {|n,i| n + i }
  puts "#{s}\t#{sum}\t#{rolls.join(', ')}"
  sum
})
```

```console
$ ./roll 2d6 + 3d4
2d6    7    2, 5
3d4    11   3, 4, 4
18
$ ./roll 2d6 + 3d4
2d6    5    4, 1
3d4    6    3, 1, 2
11
$ ./roll 2d6 + 3d4
2d6    5    4, 1
3d4    9    4, 2, 3
14
```
