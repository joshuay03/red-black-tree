## [Unreleased]

## [0.1.7] - 2025-01-05

- Change `RedBlackTree#delete!` return value to the deleted node
- Add `RedBlackTree#clear!`

## [0.1.6] - 2025-01-01

- Prefer node deletion over data swapping

## [0.1.5] - 2024-10-28

- Alias `RedBlackTree#search` as `RedBlackTree#find`
- Add `RedBlackTree#select`, aliased as `RedBlackTree#filter` and `RedBlackTree#find_all`

## [0.1.4] - 2024-10-27

- Fix incorrect `super` fallback in `RedBlackTree::DataDelegation#respond_to_missing?`

## [0.1.3] - 2024-10-21

- Make `RedBlackTree#left_most_node` public
- Add `RedBlackTree#traverse_pre_order`
- Add `RedBlackTree#traverse_in_order`
- Add `RedBlackTree#traverse_post_order`
- Add `RedBlackTree#traverse_level_order`
- Add `RedBlackTree#traverse`, alias of `RedBlackTree#traverse_in_order`
- Extend `RedBlackTree#search` to accept a block
- Delegate missing `RedBlackTree::Node` methods to its `#data`

## [0.1.2] - 2024-09-08

- Fix a bunch of issues in `RedBlackTree#insert!` and `RedBlackTree#delete!` algorithms
- Fix `RedBlackTree::LeafNode`s being marked red
- Handle comparison with `RedBlackTree::LeafNode` in subclasses of `RedBlackTree::Node`
- Add `RedBlackTree#include?`
- Add `RedBlackTree#search`
- Alias `RedBlackTree#left_most_node` as `RedBlackTree#min`

## [0.1.1] - 2024-08-04

- Update `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` in README

## [0.1.0] - 2024-08-04

- Initial release
