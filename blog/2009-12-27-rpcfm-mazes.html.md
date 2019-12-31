---
title: "RPCFM: Mazes"
...

[Ruby Programming Challenge For Newbies: Mazes (#5)](http://rubylearning.com/blog/2009/12/27/rpcfn-mazes-5/) came across my radar this morning, and although I'm not a Ruby newbie, I thought it might be a fun warmup for the day. And it was! My solution follows:

```ruby
class Maze
  class Node
    attr_accessor :x, :y, :distance

    def initialize(x, y, distance=0)
      @x = x
      @y = y
      @distance = distance
    end

    def coords
      [x, y]
    end

    def neighbors
      [[@x-1,@y], [@x+1,@y], [@x,@y-1], [@x,@y+1]].map {|x,y| Node.new(x, y, @distance+1) }
    end
  end

  # assumptions:
  # * only one A
  # * only one B
  # maze is bounded on all four sides
  def initialize(maze_str)
    @maze = maze_str.dup
    @width = @maze.index("\n") + 1 # add one to account for the "\n"s
    a = @maze.index('A')

    start_coords = a.divmod(@width).reverse
    @start_node = Node.new(*start_coords)
    @end_node = nil

    @nodes = [ @start_node ]

    calculate
  end

  def calculate
    loop do
      node = @nodes.shift

      node.neighbors.each do |neighbor|
        case @maze[coords_to_index(*neighbor.coords)].chr
        when ' '
          @maze[coords_to_index(*neighbor.coords)] = 'x'
          @nodes << neighbor
        when 'B'
          @end_node = neighbor
          return
        end
      end

      return if @nodes.empty?

      @nodes.sort_by!(&:distance)
    end
  end

  def solvable?
    !!@end_node
  end

  def steps
    @end_node.distance rescue 0
  end

  def coords_to_index(x, y)
    y * @width + x
  end
end
```

**Edit:** And for fun, here's a slightly golfed version:

```ruby
class Maze
  def initialize(s)
    @m = s.dup
    @d = r(@m.index('A'),@m.index("\n")+1)
  end

  def r(a,w)
    n = [[1,a]]
    until n.empty? do
      d,i = n.shift
      [i-w,i+w,i-1,i+1].each do |j|
        case @m[j]
        when 32
          @m[j] = 'x'
          n << [d+1,j]
        when 66
          return d
        end
      end
      n.sort!
    end
    nil
  end

  def solvable?; !!@d; end
  def steps; @d || 0; end
end
```
