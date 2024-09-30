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

### Sort and iterate 10,000 elements

```ruby
require 'benchmark/ips'

Work = Struct.new :min_latency, keyword_init: true

class WorkNode < RedBlackTree::Node
  def <=> other
    self.data.min_latency <=> other.data.min_latency
  end
end

sample_data = 10_000.times.map { Work.new(min_latency: rand(1_000)) }

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
#=>         RedBlackTree      5.444 (± 0.0%) i/s  (183.69 ms/i) -     28.000 in   5.145867s
#=>                Array      0.247 (± 0.0%) i/s     (4.04 s/i) -      2.000 in   8.084148s
#=>
#=> Comparison:
#=>         RedBlackTree:        5.4 i/s
#=>                Array:        0.2 i/s - 22.00x  slower
```

### Sort and search 10,000 elements

```ruby
require 'benchmark/ips'

Work = Struct.new :min_latency, keyword_init: true

class WorkNode < RedBlackTree::Node
  def <=> other
    self.data.min_latency <=> other.data.min_latency
  end
end

sample_data = 10_000.times.map { Work.new(min_latency: rand(1_000)) }
search_sample = sample_data.sample

Benchmark.ips do |x|
  x.report("RedBlackTree#search") do
    tree = RedBlackTree.new
    sample_data.each { |work| tree << WorkNode.new(work); }
    raise unless tree.search search_sample
  end

  x.report("Array#find") do
    array = []
    sample_data.each { |work| array << work; array.sort_by!(&:min_latency); }
    raise unless array.find { |work| work.min_latency == search_sample.min_latency }
  end

  x.report("Array#bsearch") do
    array = []
    sample_data.each { |work| array << work; array.sort_by!(&:min_latency); }
    raise unless array.bsearch { |work| search_sample.min_latency <= work.min_latency }
  end

  x.compare!
end

#=> ruby 3.3.4 (2024-07-09 revision be1089c8ec) [arm64-darwin24]
#=> Warming up --------------------------------------
#=>  RedBlackTree#search     1.000 i/100ms
#=>           Array#find     1.000 i/100ms
#=>        Array#bsearch     1.000 i/100ms
#=> Calculating -------------------------------------
#=>  RedBlackTree#search     12.175 (± 0.0%) i/s   (82.14 ms/i) -     61.000 in   5.013347s
#=>           Array#find      0.261 (± 0.0%) i/s     (3.84 s/i) -      2.000 in   7.671248s
#=>        Array#bsearch      0.256 (± 0.0%) i/s     (3.91 s/i) -      2.000 in   7.821081s
#=>
#=> Comparison:
#=>  RedBlackTree#search:       12.2 i/s
#=>           Array#find:        0.3 i/s - 46.70x  slower
#=>        Array#bsearch:        0.3 i/s - 47.61x  slower
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
