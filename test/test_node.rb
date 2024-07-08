# frozen_string_literal: true

require "test_helper"

class TestNode < Minitest::Test
  def test_new_node
    node = RedBlackTree::Node.new "root"
    assert_nil node.colour
    assert_nil node.parent
    assert_nil node.left
    assert_nil node.right
  end

  def test_new_node_with_nil_data
    error = assert_raises do
      RedBlackTree::Node.new nil
    end
    assert_equal "data cannot be nil", error.message
  end

  def test_new_leaf_node
    node = RedBlackTree::LeafNode.new
    assert node.black?
    assert_nil node.parent
    assert_nil node.left
    assert_nil node.right
  end
end
