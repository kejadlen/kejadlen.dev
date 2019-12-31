---
title: "RubyQuiz #148: Postfix to Infix"
...

My extremely lazy whack at the latest Ruby Quiz. Turns a postfix expression into an infix expression via regular expressions.

```ruby
str = ARGV[0].split(/\s+/).join('_')

while str.include?('_')
  str.sub!(/([^_]+)_([^_]+)_([+\-*\/])/, '(\1 \3 \2)')
end

puts str
```

A few test cases I used in developing the solution before turning it into an actual script:

```ruby
require 'test/unit'

def postfix_to_infix(str)
  str = str.split(/[^.\d+\-*\/]/).join(' ')
  while str !~ /^\(.*\)$/
    str.sub!(/([^ ]+) ([^ ]+) ([+\-*\/])/, '(\1\3\2)')
  end
  str.gsub(/([+\-*\/])/, ' \1 ').sub(/^\((.*)\)$/, '\1')
end

class PostfixToInfixTest < Test::Unit::TestCase
  def test_postfix_to_infix
    assert_equal '2 + 3', postfix_to_infix('2 3 +')
    assert_equal '12 + 34', postfix_to_infix('12 34 +')
    assert_equal '1.2 + 3.4', postfix_to_infix('1.2 3.4 +')
    assert_equal '(1 - 2) - (3 + 4)', postfix_to_infix('1 2 - 3 4 + -')
    assert_equal '(56 * (34 + 213.7)) - 678', postfix_to_infix('56 34 213.7 + * 678 -')
  end
end
```
