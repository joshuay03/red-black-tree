# RedBlackTree

[Red-black tree](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree) data structure for Ruby.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add red-black-tree

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install red-black-tree

## Usage

```ruby
Work = Struct.new :min_latency, keyword_init: true

# Needs to be implemented by you
class WorkNode < RedBlackTree::Node
  def <=> other
    self.data.min_latency <=> other.data.min_latency
  end
end

tree = RedBlackTree.new

tree << WorkNode.new(Work.new min_latency: 0.8)
tree << WorkNode.new(Work.new min_latency: 1.2)
tree << WorkNode.new(Work.new min_latency: 0.8)
tree << WorkNode.new(Work.new min_latency: 0.4)

until tree.empty?
  work = tree.shift # 0.4, 0.8, 0.8, 1.2
  # process work
end
```

## Performance

```ruby
require 'benchmark/ips'

Work = Struct.new :min_latency, keyword_init: true

class WorkNode < RedBlackTree::Node
  def <=> other
    self.data.min_latency <=> other.data.min_latency
  end
end

sample_data = 10_000.times.map { Work.new(min_latency: rand(100)) }

Benchmark.ips do |x|
  x.report("RedBlackTree") do
    tree = RedBlackTree.new
    sample_data.each { |work| tree << WorkNode.new(work); }
    tree.shift until tree.empty?
  end

  x.report("Array") do
    array = []
    sample_data.each { |work| array << work; array.sort_by!(&:min_latency); }
    array.shift until array.empty?
  end

  x.compare!
end

#=> ruby 3.3.4 (2024-07-09 revision be1089c8ec) [arm64-darwin24]
#=> Warming up --------------------------------------
#=>         RedBlackTree     1.000 i/100ms
#=>                Array     1.000 i/100ms
#=> Calculating -------------------------------------
#=>         RedBlackTree      5.174 (± 0.0%) i/s  (193.27 ms/i) -     26.000 in   5.031399s
#=>                Array      0.267 (± 0.0%) i/s     (3.75 s/i) -      2.000 in   7.501007s
#=>
#=> Comparison:
#=>         RedBlackTree:        5.2 i/s
#=>                Array:        0.3 i/s - 19.40x  slower
```

## WIP Features

- `RedBlackTree#traverse_in_order`
- `RedBlackTree#traverse_pre_order`
- `RedBlackTree#traverse_post_order`
- `RedBlackTree#traverse_level_order`
- `RedBlackTree#traverse` (default in-order)
- `RedBlackTree#max`
- `RedBlackTree#height`
- `RedBlackTree#clear`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` to run the
tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshuay03/red-black-tree.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RedBlackTree project's codebases, issue trackers, chat rooms and mailing lists is expected
to follow the [code of conduct](https://github.com/joshuay03/red-black-tree/blob/main/CODE_OF_CONDUCT.md).
