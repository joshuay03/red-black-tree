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

  def test_node_data_delegation
    node = RedBlackTree::Node.new "root"
    assert node.respond_to? :length
    assert_equal 4, node.length
    assert node.respond_to? :chars
    assert_equal "r", node.chars.first
    refute node.respond_to? :non_existent_string_method
    error = assert_raises do
      node.non_existent_string_method
    end
    assert_equal "undefined method `non_existent_string_method' for an instance of RedBlackTree::Node", error.message
  end
end
