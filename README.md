# RedBlackTree

![Version](https://img.shields.io/gem/v/red-black-tree)
![Build](https://badge.buildkite.com/6ccbd68c23960899d1deafdb4cfaa96f1e8c04ad6e198e193b.svg)

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

> [!NOTE]
> Red-black trees are designed for specific use cases and are not intended as a general-purpose data structure. The
comparisons below are provided merely to illustrate the performance characteristics of the gem. However, it is important
to note that the benchmarks do not take into account the self-balancing nature of red-black trees.

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

  # 1:1 comparison
  x.report("Array (gradual sort)") do
    array = []
    sample_data.each { |work| array << work; array.sort_by!(&:min_latency); }
    array.shift until array.empty?
  end

  x.report("Array (single sort)") do
    array = []
    sample_data.each { |work| array << work; }
    array.sort_by!(&:min_latency)
    array.shift until array.empty?
  end

  x.compare!
end

#=> ruby 4.0.3 (2026-04-21 revision 85ddef263a) +YJIT +PRISM [arm64-darwin23]
#=> Warming up --------------------------------------
#=>         RedBlackTree     1.000 i/100ms
#=> Array (gradual sort)     1.000 i/100ms
#=>  Array (single sort)    81.000 i/100ms
#=> Calculating -------------------------------------
#=>         RedBlackTree     12.170 (± 8.2%) i/s   (82.17 ms/i) -     61.000 in   5.023274s
#=> Array (gradual sort)      0.208 (± 0.0%) i/s     (4.82 s/i) -      2.000 in   9.632733s
#=>  Array (single sort)    815.762 (± 1.2%) i/s    (1.23 ms/i) -      4.131k in   5.064788s
#=> 
#=> Comparison:
#=>  Array (single sort):      815.8 i/s
#=>         RedBlackTree:       12.2 i/s - 67.03x  slower
#=> Array (gradual sort):        0.2 i/s - 3928.64x  slower
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
    raise unless tree.search { |node| node.data == search_sample }
  end

  # 1:1 comparison
  x.report("Array#find (gradual sort)") do
    array = []
    sample_data.each { |work| array << work; array.sort_by!(&:min_latency); }
    raise unless array.find { |work| work.min_latency == search_sample.min_latency }
  end

  x.report("Array#find (single sort)") do
    array = []
    sample_data.each { |work| array << work; }
    array.sort_by!(&:min_latency)
    raise unless array.find { |work| work.min_latency == search_sample.min_latency }
  end

  # 1:1 comparison
  x.report("Array#bsearch (gradual sort)") do
    array = []
    sample_data.each { |work| array << work; array.sort_by!(&:min_latency); }
    raise unless array.bsearch { |work| search_sample.min_latency <= work.min_latency }
  end

  x.report("Array#bsearch (single sort)") do
    array = []
    sample_data.each { |work| array << work; }
    array.sort_by!(&:min_latency)
    raise unless array.bsearch { |work| search_sample.min_latency <= work.min_latency }
  end

  x.compare!
end

#=> ruby 4.0.3 (2026-04-21 revision 85ddef263a) +YJIT +PRISM [arm64-darwin23]
#=> Warming up --------------------------------------
#=>  RedBlackTree#search     3.000 i/100ms
#=> Array#find (gradual sort)
#=>                          1.000 i/100ms
#=> Array#find (single sort)
#=>                         79.000 i/100ms
#=> Array#bsearch (gradual sort)
#=>                          1.000 i/100ms
#=> Array#bsearch (single sort)
#=>                         87.000 i/100ms
#=> Calculating -------------------------------------
#=>  RedBlackTree#search     32.188 (± 6.2%) i/s   (31.07 ms/i) -    162.000 in   5.051229s
#=> Array#find (gradual sort)
#=>                           0.207 (± 0.0%) i/s     (4.83 s/i) -      2.000 in   9.651532s
#=> Array#find (single sort)
#=>                         809.310 (± 3.8%) i/s    (1.24 ms/i) -      4.108k in   5.084020s
#=> Array#bsearch (gradual sort)
#=>                           0.205 (± 0.0%) i/s     (4.88 s/i) -      2.000 in   9.753754s
#=> Array#bsearch (single sort)
#=>                         857.497 (± 1.0%) i/s    (1.17 ms/i) -      4.350k in   5.073414s
#=> 
#=> Comparison:
#=> Array#bsearch (single sort):      857.5 i/s
#=> Array#find (single sort):      809.3 i/s - 1.06x  slower
#=>  RedBlackTree#search:       32.2 i/s - 26.64x  slower
#=> Array#find (gradual sort):        0.2 i/s - 4138.00x  slower
#=> Array#bsearch (gradual sort):        0.2 i/s - 4181.79x  slower
```

## WIP Features

- `RedBlackTree#max`
- `RedBlackTree#height`

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
