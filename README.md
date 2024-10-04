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

#=> ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [arm64-darwin24]
#=> Warming up --------------------------------------
#=>         RedBlackTree     1.000 i/100ms
#=> Array (gradual sort)     1.000 i/100ms
#=>  Array (single sort)    78.000 i/100ms
#=> Calculating -------------------------------------
#=>         RedBlackTree      5.417 (± 0.0%) i/s  (184.61 ms/i) -     28.000 in   5.172532s
#=> Array (gradual sort)      0.268 (± 0.0%) i/s     (3.74 s/i) -      2.000 in   7.473005s
#=>  Array (single sort)    768.691 (± 2.2%) i/s    (1.30 ms/i) -      3.900k in   5.076337s
#=>
#=> Comparison:
#=>  Array (single sort):      768.7 i/s
#=>         RedBlackTree:        5.4 i/s - 141.91x  slower
#=> Array (gradual sort):        0.3 i/s - 2872.03x  slower
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

#=> ruby 3.3.5 (2024-09-03 revision ef084cc8f4) [arm64-darwin24]
#=> Warming up --------------------------------------
#=>  RedBlackTree#search     1.000 i/100ms
#=> Array#find (gradual sort)
#=>                          1.000 i/100ms
#=> Array#find (single sort)
#=>                         69.000 i/100ms
#=> Array#bsearch (gradual sort)
#=>                          1.000 i/100ms
#=> Array#bsearch (single sort)
#=>                         89.000 i/100ms
#=> Calculating -------------------------------------
#=>  RedBlackTree#search     12.926 (± 0.0%) i/s   (77.36 ms/i) -     65.000 in   5.030736s
#=> Array#find (gradual sort)
#=>                           0.262 (± 0.0%) i/s     (3.81 s/i) -      2.000 in   7.623953s
#=> Array#find (single sort)
#=>                         690.631 (± 1.0%) i/s    (1.45 ms/i) -      3.519k in   5.095823s
#=> Array#bsearch (gradual sort)
#=>                           0.267 (± 0.0%) i/s     (3.75 s/i) -      2.000 in   7.492482s
#=> Array#bsearch (single sort)
#=>                         895.413 (± 1.7%) i/s    (1.12 ms/i) -      4.539k in   5.070590s
#=>
#=> Comparison:
#=> Array#bsearch (single sort):      895.4 i/s
#=> Array#find (single sort):         690.6 i/s - 1.30x  slower
#=> RedBlackTree#search:               12.9 i/s - 69.27x  slower
#=> Array#bsearch (gradual sort):       0.3 i/s - 3354.39x  slower
#=> Array#find (gradual sort):          0.3 i/s - 3412.57x  slower
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
