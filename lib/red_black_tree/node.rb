# frozen_string_literal: true

require_relative "utils"
require_relative "node/leaf_node_comparable"
require_relative "node/left_right_element_referencers"

class RedBlackTree
  class Node
    class << self
      def inherited subclass
        subclass.prepend LeafNodeComparable
      end
    end

    include Comparable

    # @return [any] the data/value representing the node
    attr_reader :data

    # @param data [any] a non-nil data/value representing the node
    # @return [Node] a new instance of Node
    def initialize data
      raise ArgumentError, "data cannot be nil" if data.nil? && !(instance_of? RedBlackTree::LeafNode)

      @data = data
      @colour = nil
      @parent = @left = @right = nil

      validate_free!
    end

    # Needs to be implemented in a subclass of {Node}.
    # Will be used to calculate the ideal position of this node when adding it
    # to a tree.
    def <=> other
      raise NotImplementedError, "Comparable operator <=> must be implemented in subclass"
    end

    module Implementation # @private
      class StructuralError < StandardError; end

      include Utils

      RED = "red"
      BLACK = "black"
      COLOURS = [RED, BLACK].freeze

      LEFT = "left"
      RIGHT = "right"
      DIRECTIONS = [LEFT, RIGHT].freeze

      attr_writer :data
      attr_accessor :colour
      attr_accessor :tree, :parent
      attr_accessor :left, :right
      include LeftRightElementReferencers

      def red? = @colour == RED
      def red! = @colour = RED

      def black? = @colour == BLACK
      def black! = @colour = BLACK

      def leaf? = black? && (instance_of? RedBlackTree::LeafNode)
      def valid? = (red? || black?) && !(instance_of? RedBlackTree::LeafNode)

      def children_are_leaves? = children.all?(&:leaf?)
      def children_are_valid? = children.all?(&:valid?)
      def single_child_is_leaf? = children.any?(&:leaf?) && !children_are_leaves?
      alias_method :single_child_is_valid?, :single_child_is_leaf?

      def position
        return unless @parent

        case self.object_id
        when @parent.left.object_id then LEFT
        when @parent.right.object_id then RIGHT
        else raise StructuralError, "Disowned by parent"
        end
      end

      def opposite_position
        return unless @parent

        opposite_direction position
      end

      def children
        [@left, @right]
      end

      def sibling
        return unless @parent

        @parent[opposite_position]
      end

      def close_nephew
        return unless sibling

        sibling[position]
      end

      def distant_nephew
        return unless sibling

        sibling[opposite_position]
      end

      def validate! is_root = false
        return if (@parent || is_root) && @left && @right

        raise StructuralError, "Node is invalid"
      end

      def validate_free!
        anchors = []
        anchors << "parent" if @parent
        anchors << "left child" if @left && @left.valid?
        anchors << "right child" if @right && @right.valid?
        return if anchors.empty?

        raise StructuralError, "Node is still chained to #{anchors.join(", ")}"
      end

      def swap_data_with! other_node
        temp_data = @data
        @data = other_node.data
        other_node.data = temp_data
      end

      def swap_colour_with! other_node
        temp_colour = @colour

        case other_node.colour
        when RED then red!
        when BLACK then black!
        end

        case temp_colour
        when RED then other_node.red!
        when BLACK then other_node.black!
        end
      end

      def swap_position_with! other_node
        self_position = position
        other_position = other_node.position

        if other_node.parent.object_id == self.object_id
          self[other_position] = other_node[other_position]
          other_node[other_position] = self

          other_node.parent = @parent
          @parent = other_node
        elsif other_node.object_id == @parent.object_id
          other_node[self_position] = self[self_position]
          self[self_position] = other_node

          temp_parent = other_node.parent
          other_node.parent = self
          @parent = temp_parent
        else
          other_node.parent[other_position] = self if other_node.parent
          @parent[self_position] = other_node if @parent

          temp_parent = other_node.parent
          other_node.parent = @parent
          @parent = temp_parent
        end
      end
    end

    self.include Implementation
  end
end
