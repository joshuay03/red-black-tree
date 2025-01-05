# frozen_string_literal: true

require "test_helper"

class TestRedBlackTree < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil RedBlackTree::VERSION
  end

  def test_new_tree
    tree = RedBlackTree.new
    assert_equal 0, tree.size
    assert_nil tree.root
    assert_nil tree.left_most_node
  end

  class TestInsert < Minitest::Test
    def test_new_tree_insert
      tree = RedBlackTree.new
      node = StringNode.new "root"
      tree.insert! node
      assert_equal 1, tree.size
      assert_equal node, (root_node = tree.root)
      assert root_node.black?
      assert root_node.left.leaf?
      assert root_node.right.leaf?
      assert_equal root_node, tree.left_most_node
    end

    def test_new_tree_insert_leaf
      tree = RedBlackTree.new
      leaf_node = RedBlackTree::LeafNode.new
      error = assert_raises ArgumentError do
        tree.insert! leaf_node
      end
      assert_equal "cannot insert leaf node", error.message
    end

    def test_single_node_tree_insert
      tree = RedBlackTree.new
      node_root = StringNode.new "root"
      tree.insert! node_root
      assert_equal 1, tree.size
      assert_equal node_root, (root_node = tree.root)
      assert root_node.black?
      assert root_node.left.leaf?
      assert root_node.right.leaf?
      assert_equal root_node, tree.left_most_node

      node_left_child = StringNode.new "left child"
      tree.insert! node_left_child, root_node, RedBlackTree::Node::LEFT
      assert_equal 2, tree.size
      assert_equal node_left_child, root_node.left
      assert node_left_child.red?
      assert node_left_child.left.leaf?
      assert node_left_child.right.leaf?
      assert_equal node_left_child, tree.left_most_node
    end

    def test_single_node_tree_insert_without_parent
      tree = RedBlackTree.new
      node_root_1 = StringNode.new "root 1"
      tree.insert! node_root_1
      assert_equal 1, tree.size
      assert_equal node_root_1, (root_node = tree.root)
      assert root_node.black?
      assert root_node.left.leaf?
      assert root_node.right.leaf?
      assert_equal root_node, tree.left_most_node

      node_root_2 = StringNode.new "root 2"
      error = assert_raises ArgumentError do
        tree.insert! node_root_2
      end
      assert_equal error.message, "Target parent must be provided for tree with root"
    end

    def test_single_node_tree_insert_without_direction
      tree = RedBlackTree.new
      node_root = StringNode.new "root"
      tree.insert! node_root
      assert_equal 1, tree.size
      assert_equal node_root, (root_node = tree.root)
      assert root_node.black?
      assert root_node.left.leaf?
      assert root_node.right.leaf?
      assert_equal root_node, tree.left_most_node

      node_child = StringNode.new "child"
      error = assert_raises ArgumentError do
        tree.insert! node_child, root_node
      end
      assert_equal error.message, "Target parent direction must be provided"
    end

    def test_sub_tree_insert
      tree = RedBlackTree.new
      node_root = StringNode.new "root"
      tree.insert! node_root
      assert_equal 1, tree.size
      assert_equal node_root, (root_node = tree.root)
      assert root_node.black?
      assert root_node.left.leaf?
      assert root_node.right.leaf?
      assert_equal root_node, tree.left_most_node

      node_left_child = StringNode.new "left child"
      tree.insert! node_left_child, root_node, RedBlackTree::Node::LEFT
      assert_equal 2, tree.size
      assert_equal node_left_child, root_node.left
      assert node_left_child.red?
      assert node_left_child.left.leaf?
      assert node_left_child.right.leaf?
      assert_equal node_left_child, tree.left_most_node

      node_left_childs_right_child = StringNode.new "left child's right child"
      tree.insert! node_left_childs_right_child, node_left_child, RedBlackTree::Node::RIGHT
      assert_equal 3, tree.size
      assert_equal "left child's right child", (root_node = tree.root).data
      assert root_node.black?
      assert_equal "left child", (node_left_child = root_node.left).data
      assert node_left_child.red?
      assert node_left_child.left.leaf?
      assert node_left_child.right.leaf?
      assert_equal "root", (node_right_child = root_node.right).data
      assert node_right_child.red?
      assert node_right_child.left.leaf?
      assert node_right_child.right.leaf?
      assert_equal node_left_child, tree.left_most_node
    end

    def test_sub_tree_insert_with_existing_child
      tree = RedBlackTree.new
      node_root = StringNode.new "root"
      tree.insert! node_root
      assert_equal 1, tree.size
      assert_equal node_root, (root_node = tree.root)
      assert root_node.black?
      assert root_node.left.leaf?
      assert root_node.right.leaf?
      assert_equal root_node, tree.left_most_node

      node_left_child_1 = StringNode.new "left child 1"
      tree.insert! node_left_child_1, root_node, RedBlackTree::Node::LEFT
      assert_equal 2, tree.size
      assert_equal node_left_child_1, root_node.left
      assert node_left_child_1.red?
      assert node_left_child_1.left.leaf?
      assert node_left_child_1.right.leaf?
      assert_equal node_left_child_1, tree.left_most_node

      node_left_child_2 = StringNode.new "left child 2"
      error = assert_raises ArgumentError do
        tree.insert! node_left_child_2, root_node, RedBlackTree::Node::LEFT
      end
      assert_equal error.message, "Target parent already has left child"
    end
  end

  class TestAdd < Minitest::Test
    def test_new_tree_add
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node
    end

    def test_new_tree_add_leaf
      tree = RedBlackTree.new
      leaf_node = RedBlackTree::LeafNode.new
      error = assert_raises ArgumentError do
        tree << leaf_node
      end
      assert_equal "cannot add leaf node", error.message
    end

    def test_single_node_tree_add_lesser_node
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_5, root_node_10.left
      assert node_5.red?
      assert node_5.left.leaf?
      assert node_5.right.leaf?
      assert_equal node_5, tree.left_most_node
    end

    def test_single_node_tree_add_greater_node
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_15 = IntegerNode.new 15
      tree << node_15
      assert_equal 2, tree.size
      assert_equal node_15, root_node_10.right
      assert node_15.red?
      assert node_15.left.leaf?
      assert node_15.right.leaf?
      assert_equal root_node_10, tree.left_most_node
    end

    def test_single_node_tree_add_equal_node
      tree = RedBlackTree.new
      node_10_1 = IntegerNode.new 10
      tree << node_10_1
      assert_equal 1, tree.size
      assert_equal node_10_1, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_10_2 = IntegerNode.new 10
      tree << node_10_2
      assert_equal 2, tree.size
      assert_equal node_10_2, root_node_10.right
      assert node_10_2.red?
      assert node_10_2.left.leaf?
      assert node_10_2.right.leaf?
      assert_equal root_node_10, tree.left_most_node
    end

    def test_sub_tree_add_equal_node
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_5_1 = IntegerNode.new 5
      tree << node_5_1
      assert_equal 2, tree.size
      assert_equal node_5_1, root_node_10.left
      assert node_5_1.red?
      assert node_5_1.left.leaf?
      assert node_5_1.right.leaf?
      assert_equal node_5_1, tree.left_most_node

      node_5_2 = IntegerNode.new 5
      tree << node_5_2
      assert_equal 3, tree.size
      assert_equal 5, (root_node_5_1 = tree.root).data
      assert root_node_5_1.black?
      assert 5, (node_5_2 = root_node_5_1.left).data
      assert node_5_2.left.leaf?
      assert node_5_2.right.leaf?
      assert 10, (node_10 = root_node_5_1.right).data
      assert node_10.left.leaf?
      assert node_10.right.leaf?
      assert_equal node_5_2, tree.left_most_node
    end
  end

  class TestDelete < Minitest::Test
    def test_delete_leaf
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert (leaf_node = root_node_10.left).leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      error = assert_raises ArgumentError do
        tree.delete! leaf_node
      end
      assert_equal "cannot delete leaf node", error.message
    end

    def test_delete_tree_less_node
      tree = RedBlackTree.new
      assert_equal 0, tree.size
      assert_nil tree.root
      assert_nil tree.left_most_node

      node_10 = IntegerNode.new 10
      assert_nil tree.delete! node_10
      assert_equal 0, tree.size
      assert_nil tree.root
      assert_nil tree.left_most_node
    end

    def test_delete_different_tree_node
      tree_1 = RedBlackTree.new
      assert_equal 0, tree_1.size
      assert_nil tree_1.root
      assert_nil tree_1.left_most_node

      tree_2 = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree_2 << node_10
      assert_equal 1, tree_2.size
      assert_equal node_10, tree_2.root
      assert_equal node_10, tree_2.left_most_node

      error = assert_raises ArgumentError do
        tree_1.delete! node_10
      end
      assert_equal "node does not belong to this tree", error.message
    end

    def test_delete_root_node_with_valid_children
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_5, root_node_10.left
      assert node_5.red?
      assert node_5.left.leaf?
      assert node_5.right.leaf?
      assert_equal node_5, tree.left_most_node

      node_15 = IntegerNode.new 15
      tree << node_15
      assert_equal 3, tree.size
      assert_equal node_15, root_node_10.right
      assert node_15.red?
      assert node_15.left.leaf?
      assert node_15.right.leaf?
      assert_equal node_5, tree.left_most_node

      assert_equal root_node_10, (tree.delete! root_node_10)
      assert_equal 2, tree.size
      assert_equal 5, (root_node_5 = tree.root).data
      assert root_node_5.black?
      assert root_node_5.left.leaf?
      assert_equal 15, (node_15 = root_node_5.right).data
      assert node_15.red?
      assert node_15.left.leaf?
      assert node_15.right.leaf?
      assert_equal root_node_5, tree.left_most_node
    end

    def test_delete_non_root_node_with_valid_children
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_5, root_node_10.left
      assert node_5.red?
      assert node_5.left.leaf?
      assert node_5.right.leaf?
      assert_equal node_5, tree.left_most_node

      node_15 = IntegerNode.new 15
      tree << node_15
      assert_equal 3, tree.size
      assert_equal node_15, root_node_10.right
      assert node_15.red?
      assert node_15.left.leaf?
      assert node_15.right.leaf?
      assert_equal node_5, tree.left_most_node

      node_1 = IntegerNode.new 1
      tree << node_1
      assert_equal 4, tree.size
      assert_equal node_1, node_5.left
      assert node_1.red?
      assert node_1.left.leaf?
      assert node_1.right.leaf?
      assert_equal node_1, tree.left_most_node

      assert node_5.black?
      assert node_15.black?

      node_9 = IntegerNode.new 9
      tree << node_9
      assert_equal 5, tree.size
      assert_equal node_9, node_5.right
      assert node_9.red?
      assert node_9.left.leaf?
      assert node_9.right.leaf?
      assert_equal node_1, tree.left_most_node

      assert node_5.children_are_valid?

      assert_equal node_5, (tree.delete! node_5)
      assert_equal 4, tree.size
      assert_equal 10, (root_node_10 = tree.root).data
      assert root_node_10.black?
      assert_equal 1, (node_1 = root_node_10.left).data
      assert node_1.black?
      assert_equal 9, (node_9 = node_1.right).data
      assert node_9.red?
      assert_equal 15, (node_15 = root_node_10.right).data
      assert node_15.black?
      assert_equal node_1, tree.left_most_node
    end

    def test_delete_root_node_with_single_valid_child
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_5, root_node_10.left
      assert node_5.red?
      assert node_5.left.leaf?
      assert node_5.right.leaf?
      assert_equal node_5, tree.left_most_node

      assert_equal root_node_10, (tree.delete! root_node_10)
      assert_equal 1, tree.size
      assert_equal 5, (root_node_5 = tree.root).data
      assert root_node_5.black?
      assert root_node_5.left.leaf?
      assert root_node_5.right.leaf?
      assert_equal root_node_5, tree.left_most_node
    end

    def test_delete_root_node_with_single_valid_equal_child
      tree = RedBlackTree.new
      node_10_1 = IntegerNode.new 10
      tree << node_10_1
      assert_equal 1, tree.size
      assert_equal node_10_1, (root_node_10_1 = tree.root)
      assert root_node_10_1.black?
      assert root_node_10_1.left.leaf?
      assert root_node_10_1.right.leaf?
      assert_equal root_node_10_1, tree.left_most_node

      node_10_2 = IntegerNode.new 10
      tree << node_10_2
      assert_equal 2, tree.size
      assert_equal node_10_2, root_node_10_1.right
      assert node_10_2.red?
      assert node_10_2.left.leaf?
      assert node_10_2.right.leaf?
      assert_equal node_10_2, tree.left_most_node

      assert_equal root_node_10_1, (tree.delete! root_node_10_1)
      assert_equal 1, tree.size
      assert_equal 10, (root_node_10 = tree.root).data
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node
    end

    def test_delete_non_root_node_with_single_valid_child
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_5, root_node_10.left
      assert node_5.red?
      assert node_5.left.leaf?
      assert node_5.right.leaf?
      assert_equal node_5, tree.left_most_node

      node_15 = IntegerNode.new 15
      tree << node_15
      assert_equal 3, tree.size
      assert_equal node_15, root_node_10.right
      assert node_15.red?
      assert node_15.left.leaf?
      assert node_15.right.leaf?
      assert_equal node_5, tree.left_most_node

      node_1 = IntegerNode.new 1
      tree << node_1
      assert_equal 4, tree.size
      assert_equal node_1, node_5.left
      assert node_1.red?
      assert node_1.left.leaf?
      assert node_1.right.leaf?
      assert_equal node_1, tree.left_most_node

      assert node_5.black?
      assert node_5.single_child_is_valid?
      assert node_15.black?

      assert_equal node_5, (tree.delete! node_5)
      assert_equal 3, tree.size
      assert_equal 10, (root_node_10 = tree.root).data
      assert root_node_10.black?
      assert_equal 1, (node_1 = root_node_10.left).data
      assert node_1.black?
      assert node_1.left.leaf?
      assert node_1.right.leaf?
      assert_equal 15, (node_15 = root_node_10.right).data
      assert node_15.black?
      assert node_15.left.leaf?
      assert node_15.right.leaf?
      assert_equal node_1, tree.left_most_node
    end

    def test_delete_root_node_with_leaf_children
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      assert_equal root_node_10, (tree.delete! root_node_10)
      assert_equal 0, tree.size
    end

    def test_delete_non_root_red_node_with_leaf_children
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_5, root_node_10.left
      assert node_5.red?
      assert node_5.left.leaf?
      assert node_5.right.leaf?
      assert_equal node_5, tree.left_most_node

      assert_equal node_5, (tree.delete! node_5)
      assert_equal 1, tree.size
      assert_equal 10, (root_node_10 = tree.root).data
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node
    end

    def test_delete_non_root_black_node_with_leaf_children_and_distant_nephew
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_5, root_node_10.left
      assert node_5.red?
      assert node_5.left.leaf?
      assert node_5.right.leaf?
      assert_equal node_5, tree.left_most_node

      node_15 = IntegerNode.new 15
      tree << node_15
      assert_equal 3, tree.size
      assert_equal node_15, root_node_10.right
      assert node_15.red?
      assert node_15.left.leaf?
      assert node_15.right.leaf?
      assert_equal node_5, tree.left_most_node

      node_1 = IntegerNode.new 1
      tree << node_1
      assert_equal 4, tree.size
      assert_equal node_1, node_5.left
      assert node_1.red?
      assert node_1.left.leaf?
      assert node_1.right.leaf?
      assert_equal node_1, tree.left_most_node

      assert node_5.black?
      assert node_15.black?
      assert node_15.children_are_leaves?

      assert_equal node_15, (tree.delete! node_15)
      assert_equal 3, tree.size
      assert_equal 5, (root_node_5 = tree.root).data
      assert root_node_5.black?
      assert_equal 1, (node_1 = root_node_5.left).data
      assert node_1.black?
      assert node_1.left.leaf?
      assert node_1.right.leaf?
      assert_equal 10, (node_10 = root_node_5.right).data
      assert node_10.black?
      assert node_10.left.leaf?
      assert node_10.right.leaf?
      assert_equal node_1, tree.left_most_node
    end

    def test_delete_non_root_black_node_with_leaf_children_and_close_nephew
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert root_node_10.black?
      assert root_node_10.left.leaf?
      assert root_node_10.right.leaf?
      assert_equal root_node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_5, root_node_10.left
      assert node_5.red?
      assert node_5.left.leaf?
      assert node_5.right.leaf?
      assert_equal node_5, tree.left_most_node

      node_15 = IntegerNode.new 15
      tree << node_15
      assert_equal 3, tree.size
      assert_equal node_15, root_node_10.right
      assert node_15.red?
      assert node_15.left.leaf?
      assert node_15.right.leaf?
      assert_equal node_5, tree.left_most_node

      node_9 = IntegerNode.new 9
      tree << node_9
      assert_equal 4, tree.size
      assert_equal node_9, node_5.right
      assert node_9.red?
      assert node_9.left.leaf?
      assert node_9.right.leaf?
      assert_equal node_5, tree.left_most_node

      assert node_5.black?
      assert node_15.black?
      assert node_15.children_are_leaves?

      assert_equal node_15, (tree.delete! node_15)
      assert_equal 3, tree.size
      assert_equal 9, (root_node_9 = tree.root).data
      assert root_node_9.black?
      assert_equal 5, (node_5 = root_node_9.left).data
      assert node_5.black?
      assert node_5.left.leaf?
      assert node_5.right.leaf?
      assert_equal 10, (node_10 = root_node_9.right).data
      assert node_10.black?
      assert node_10.left.leaf?
      assert node_10.right.leaf?
      assert_equal node_5, tree.left_most_node
    end
  end

  class TestClear < Minitest::Test
    def test_new_tree_clear
      tree = RedBlackTree.new
      assert_equal 0, tree.size
      assert_nil tree.root
      assert_nil tree.left_most_node

      tree.clear!
      assert_equal 0, tree.size
      assert_nil tree.root
      assert_nil tree.left_most_node
    end

    def test_single_node_tree_clear
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, tree.root
      assert_equal node_10, tree.left_most_node

      tree.clear!
      assert_equal 0, tree.size
      assert_nil tree.root
      assert_nil tree.left_most_node
    end

    def test_sub_tree_clear
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, tree.root
      assert_equal node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_10, tree.root
      assert_equal node_5, tree.left_most_node

      node_15 = IntegerNode.new 15
      tree << node_15
      assert_equal 3, tree.size
      assert_equal node_10, tree.root
      assert_equal node_5, tree.left_most_node

      tree.clear!
      assert_equal 0, tree.size
      assert_nil tree.root
      assert_nil tree.left_most_node
    end
  end

  class TestSearch < Minitest::Test
    def test_search_without_data_and_without_block
      tree = RedBlackTree.new
      error = assert_raises ArgumentError do
        tree.search
      end
      assert_equal "data must be provided for search", error.message
    end

    def test_search_with_nil_data_and_without_block
      tree = RedBlackTree.new
      error = assert_raises ArgumentError do
        tree.search nil
      end
      assert_equal "data must be provided for search", error.message
    end

    def test_search_with_data_and_block
      tree = RedBlackTree.new
      error = assert_raises ArgumentError do
        tree.search 10 do |node|
          node.data == 10
        end
      end
      assert_equal "provide either data or block, not both for search", error.message
    end

    def test_new_tree_data_search
      tree = RedBlackTree.new
      result = tree.search 10
      assert_nil result
    end

    def test_single_node_tree_data_search
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      result = tree.search 10
      assert_equal node_10, result
    end

    def test_sub_tree_data_search
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      node_5 = IntegerNode.new 5
      tree << node_5
      node_15 = IntegerNode.new 15
      tree << node_15
      node_1 = IntegerNode.new 1
      tree << node_1
      node_4 = IntegerNode.new 4
      tree << node_4
      result = tree.search 5
      assert_equal node_5, result
      result = tree.search 25
      assert_nil result
    end

    def test_new_tree_block_search
      tree = RedBlackTree.new
      result = tree.search do |node|
        node.data == 10
      end
      assert_nil result
    end

    def test_single_node_tree_block_search
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      result = tree.search do |node|
        node.data == 10
      end
      assert_equal node_10, result
    end

    def test_sub_tree_block_search
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      node_5 = IntegerNode.new 5
      tree << node_5
      node_15 = IntegerNode.new 15
      tree << node_15
      node_1 = IntegerNode.new 1
      tree << node_1
      node_4 = IntegerNode.new 4
      tree << node_4
      result = tree.search do |node|
        node.data == 5
      end
      assert_equal node_5, result
      result = tree.search do |node|
        node.data == 25
      end
      assert_nil result
    end
  end

  class TestSelect < Minitest::Test
    def test_select_without_block
      tree = RedBlackTree.new
      error = assert_raises ArgumentError do
        tree.select
      end
      assert_equal "block must be provided for select", error.message
    end

    def test_new_tree_block_select
      tree = RedBlackTree.new
      result = tree.select do |node|
        node.data == 10
      end
      assert_equal [], result
    end

    def test_single_node_tree_block_select
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      result = tree.select do |node|
        node.data == 10
      end
      assert_equal [node_10], result
    end

    def test_sub_tree_block_select
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      node_5 = IntegerNode.new 5
      tree << node_5
      node_15 = IntegerNode.new 15
      tree << node_15
      node_1 = IntegerNode.new 1
      tree << node_1
      node_4 = IntegerNode.new 4
      tree << node_4
      result = tree.select do |node|
        node.data % 5 == 0
      end
      assert_equal [node_5, node_10, node_15], result
      result = tree.select do |node|
        node.data == 25
      end
      assert_equal [], result
    end
  end

  class TestInclude < Minitest::Test
    def test_new_tree_include
      tree = RedBlackTree.new
      refute tree.include? 10
    end

    def test_single_node_tree_include
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert tree.include? 10
    end

    def test_sub_tree_include
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      node_5 = IntegerNode.new 5
      tree << node_5
      node_15 = IntegerNode.new 15
      tree << node_15
      node_1 = IntegerNode.new 1
      tree << node_1
      node_4 = IntegerNode.new 4
      tree << node_4
      assert tree.include? 5
      assert tree.include? 15
      tree.delete! node_5
      refute tree.include? 5
    end
  end

  class TestTraverseInPreOrder < Minitest::Test
    def test_order
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      node_5 = IntegerNode.new 7
      tree << node_5
      node_15 = IntegerNode.new 15
      tree << node_15
      node_1 = IntegerNode.new 1
      tree << node_1
      node_4 = IntegerNode.new 4
      tree << node_4
      node_4 = IntegerNode.new 5
      tree << node_4
      expected_order = [10, 4, 1, 7, 5, 15]
      actual_order = []
      tree.traverse_pre_order do |node|
        actual_order << node.data
      end
      assert_equal expected_order, actual_order
    end
  end

  class TestTraverseInInOrder < Minitest::Test
    def test_order
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      node_5 = IntegerNode.new 7
      tree << node_5
      node_15 = IntegerNode.new 15
      tree << node_15
      node_1 = IntegerNode.new 1
      tree << node_1
      node_4 = IntegerNode.new 4
      tree << node_4
      node_4 = IntegerNode.new 5
      tree << node_4
      expected_order = [1, 4, 5, 7, 10, 15]
      actual_order = []
      tree.traverse_in_order do |node|
        actual_order << node.data
      end
      assert_equal expected_order, actual_order
    end
  end

  class TestTraverseInPostOrder < Minitest::Test
    def test_order
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      node_5 = IntegerNode.new 7
      tree << node_5
      node_15 = IntegerNode.new 15
      tree << node_15
      node_1 = IntegerNode.new 1
      tree << node_1
      node_4 = IntegerNode.new 4
      tree << node_4
      node_4 = IntegerNode.new 5
      tree << node_4
      expected_order = [1, 5, 7, 4, 15, 10]
      actual_order = []
      tree.traverse_post_order do |node|
        actual_order << node.data
      end
      assert_equal expected_order, actual_order
    end
  end

  class TestTraverseInLevelOrder < Minitest::Test
    def test_order
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      node_5 = IntegerNode.new 7
      tree << node_5
      node_15 = IntegerNode.new 15
      tree << node_15
      node_1 = IntegerNode.new 1
      tree << node_1
      node_4 = IntegerNode.new 4
      tree << node_4
      node_4 = IntegerNode.new 5
      tree << node_4
      expected_order = [10, 4, 15, 1, 7, 5]
      actual_order = []
      tree.traverse_level_order do |node|
        actual_order << node.data
      end
      assert_equal expected_order, actual_order
    end
  end

  class TestShift < Minitest::Test
    def test_new_tree_shift
      tree = RedBlackTree.new
      assert_equal 0, tree.size
      assert_nil tree.left_most_node
      shifted_node = tree.shift
      assert_nil shifted_node
      assert_equal 0, tree.size
      assert_nil tree.left_most_node
    end

    def test_single_node_tree_shift
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, tree.left_most_node
      shifted_node = tree.shift
      assert_equal node_10, shifted_node
      assert_equal 0, tree.size
      assert_nil tree.left_most_node
    end

    def test_sub_tree_shift
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree << node_10
      assert_equal 1, tree.size
      assert_equal node_10, (root_node_10 = tree.root)
      assert_equal root_node_10, tree.left_most_node

      node_5 = IntegerNode.new 5
      tree << node_5
      assert_equal 2, tree.size
      assert_equal node_5, root_node_10.left
      assert_equal node_5, tree.left_most_node

      node_15 = IntegerNode.new 15
      tree << node_15
      assert_equal 3, tree.size
      assert_equal node_15, root_node_10.right
      assert_equal node_5, tree.left_most_node

      node_1 = IntegerNode.new 1
      tree << node_1
      assert_equal 4, tree.size
      assert_equal node_1, node_5.left
      assert_equal node_1, tree.left_most_node

      shifted_node = tree.shift
      assert_equal node_1, shifted_node
      assert_equal 3, tree.size
      assert_equal node_5, tree.left_most_node
    end
  end

  class TestEmpty < Minitest::Test
    def test_new_tree
      tree = RedBlackTree.new
      assert_equal 0, tree.size
      assert tree.empty?
    end

    def test_single_node_tree
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree.insert! node_10
      assert_equal 1, tree.size
      refute tree.empty?
    end
  end

  class TestAny < Minitest::Test
    def test_new_tree
      tree = RedBlackTree.new
      assert_equal 0, tree.size
      refute tree.any?
    end

    def test_single_node_tree
      tree = RedBlackTree.new
      node_10 = IntegerNode.new 10
      tree.insert! node_10
      assert_equal 1, tree.size
      assert tree.any?
    end
  end

  class TestIntegration < Minitest::Test
    Work = Struct.new :min_latency, keyword_init: true

    class WorkNode < RedBlackTree::Node
      def <=> other
        self.data.min_latency <=> other.data.min_latency
      end
    end

    def test_ordering
      10.times do
        tree = RedBlackTree.new
        expected = 250.times.map do
          rand(10).tap do |value|
            tree << WorkNode.new(Work.new min_latency: value)
          end
        end.sort
        assert_equal expected.shift, tree.shift.data.min_latency until tree.empty?
      end
    end
  end

  class IntegerNode < RedBlackTree::Node
    def <=> other
      self.data <=> other.data
    end
  end

  class StringNode < RedBlackTree::Node
    def <=> other
      self.data.length <=> other.data.length
    end
  end
end
