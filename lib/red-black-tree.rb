# frozen_string_literal: true

require_relative "red_black_tree/utils"
require_relative "red_black_tree/node"
require_relative "red_black_tree/node/leaf_node"

class RedBlackTree
  include Utils

  # @return [Integer] the number of valid/non-leaf nodes
  attr_reader :size

  # @private
  # @return [RedBlackTree::Node, nil] the root node
  attr_reader :root

  # @private
  # @return [RedBlackTree::Node, nil] the left most node
  attr_reader :left_most_node
  alias_method :min, :left_most_node

  def initialize
    @size = 0
    @left_most_node = nil
  end

  # Returns true if there are no valid/non-leaf nodes, and false if there are.
  #
  # @return [true, false]
  def empty?
    @size == 0
  end

  # Returns true if there are any valid/non-leaf nodes, and false if there are none.
  #
  # @return [true, false]
  def any?
    !empty?
  end

  # Removes the left most node (the node with the lowest data value) from the tree.
  #
  # @return [RedBlackTree::Node, nil] the removed node
  def shift
    node = @left_most_node
    delete! node if node
    node
  end

  # Traverses the tree, comparing existing nodes to the node to be added,
  # and inserts the node with the appropriate parent and direction.
  #
  # @param node [RedBlackTree::Node] the node to be added
  # @return [RedBlackTree] self
  def << node
    raise ArgumentError, "cannot add leaf node" if node.instance_of? LeafNode

    parent = @root
    direction = nil

    while parent
      direction = node >= parent ? Node::RIGHT : Node::LEFT
      break if (child = parent[direction]).leaf?

      parent = child
    end

    insert! node, parent, direction
  end
  alias_method :add!, :<<

  # Inserts the given node using the given direction relative to the given parent.
  #
  # @private ideally this is only used internally e.g. in #<< which has context on the ideal location for the node
  # @param node [RedBlackTree::Node] the node to be inserted
  # @param target_parent [RedBlackTree::Node, nil] the parent under which the node should be inserted
  # @param direction ["left", "right", nil] the direction of the node relative to the parent
  # @return [RedBlackTree] self
  def insert! node, target_parent = nil, direction = nil
    raise ArgumentError, "cannot insert leaf node" if node.instance_of? LeafNode

    if target_parent.nil?
      raise ArgumentError, "Target parent must be provided for tree with root" if @root
    else
      raise ArgumentError, "Target parent direction must be provided" if direction.nil?
      raise ArgumentError, "Target parent already has #{direction} child" if (child = target_parent[direction]) && child.valid?
    end

    opp_direction = opposite_direction direction if direction

    node.parent = nil
    node.left = LeafNode.new
    node.left.parent = node
    node.right = LeafNode.new
    node.right.parent = node

    if target_parent.nil?
      @root = node
      @root.black!
    else
      target_parent[direction] = node
      node.parent = target_parent
      node.red!

      while node.parent && node.parent.red? do
        if node.parent.sibling && node.parent.sibling.red?
          node.parent.black!
          node.parent.sibling.black!
          node.parent.parent.red!
          node = node.parent.parent
        else
          if node.position == direction
            node = node.parent
            rotate_sub_tree! node, opp_direction
          end

          node.parent.black!

          if node.parent.parent
            node.parent.parent.red!
            rotate_sub_tree! node.parent.parent, direction
          end
        end

        @root.black!
      end
    end

    node.validate! @root == node

    increment_size!
    update_left_most_node!

    self
  end

  # Removes the given node from the tree.
  #
  # @param node [RedBlackTree::Node] the node to be removed
  # @return [RedBlackTree] self
  def delete! node
    raise ArgumentError, "cannot delete leaf node" if node.instance_of? LeafNode

    if node.children_are_valid?
      successor = node.left
      successor = successor.left until successor.left.leaf?
      node.swap_data_with! successor

      return delete! successor
    elsif node.single_child_is_valid?
      is_root = is_root? node

      valid_child = node.children.find(&:valid?)
      node.swap_data_with! valid_child
      node.black!

      @root = node if is_root

      return delete! valid_child
    elsif node.children_are_leaves?
      if is_root? node
        @root = nil
      elsif node.red?
        leaf = LeafNode.new
        node.swap_position_with! leaf
      else
        direction = node.position
        opp_direction = opposite_direction direction

        loop do
          if node.sibling.valid? && node.sibling.red?
            node.parent.red!
            node.sibling.black!
            rotate_sub_tree! node.parent, direction

            next
          end

          if node.distant_nephew && node.distant_nephew.valid? && node.distant_nephew.red?
            case node.parent.colour
            when Node::RED then node.sibling.red!
            when Node::BLACK then node.sibling.black!
            end
            node.parent.black!
            node.distant_nephew.black!
            rotate_sub_tree! node.parent, direction

            break
          end

          if node.close_nephew && node.close_nephew.valid? && node.close_nephew.red?
            node.sibling.red!
            node.close_nephew.black!
            rotate_sub_tree! node.sibling, opp_direction

            next
          end

          if node.parent.red?
            node.sibling.red!
            node.parent.black!

            break
          end

          break
        end

        leaf = LeafNode.new
        node.swap_position_with! leaf
      end
    end

    node.validate_free!

    decrement_size!
    update_left_most_node!

    self
  end

  # Searches for a node which matches the given data/value.
  #
  # @param data [any] the data to search for
  # @return [RedBlackTree::Node, nil] the matching node
  def search data
    raise ArgumentError, "data must be provided for search" unless data

    _search data, @root
  end

  private

  # Rotates a (sub-)tree starting from the given node in the given direction.
  #
  # @param node [RedBlackTree::Node] the root node of the sub-tree
  # @param direction ["left", "right"] the direction of rotation
  # @return [RedBlackTree::Node] the new root node of the sub-tree
  def rotate_sub_tree! node, direction
    opp_direction = opposite_direction direction
    opp_direction_child = node[opp_direction]
    return node unless opp_direction_child.valid?

    node[opp_direction] = opp_direction_child[direction]
    opp_direction_child[direction].parent = node

    opp_direction_child.parent = node.parent
    if node.parent
      node.parent[node.position] = opp_direction_child
    else
      @root = opp_direction_child
    end

    opp_direction_child[direction] = node
    node.parent = opp_direction_child

    opp_direction_child
  end

  def _search data, current_node
    return if current_node.nil? || current_node.leaf?
    return current_node if data == current_node.data

    mock_node = current_node.class.new data
    if mock_node >= current_node
      _search data, current_node.right
    else
      _search data, current_node.left
    end
  end

  def is_root? node
    node && @root && node.object_id == @root.object_id
  end

  def increment_size!
    @size += 1
  end

  def decrement_size!
    @size -= 1
  end

  def update_left_most_node!
    unless @root
      @left_most_node = nil
      return
    end

    current = @root
    current = current.left until current.left.leaf?
    @left_most_node = current
  end
end
