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
