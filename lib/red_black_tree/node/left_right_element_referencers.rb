# frozen_string_literal: true

class RedBlackTree
  class Node
    module LeftRightElementReferencers # @private
      def [] direction
        validate_direction! direction
        case direction
        when Node::LEFT then @left
        when Node::RIGHT then @right
        end
      end

      def []= direction, node
        validate_direction! direction
        case direction
        when Node::LEFT then @left = node
        when Node::RIGHT then @right = node
        end
      end

      private

      def validate_direction! direction
        return if [Node::LEFT, Node::RIGHT].include?(direction)
        raise ArgumentError, "Direction must be one of #{Implementation::DIRECTIONS}, got #{direction}"
      end
    end
  end
end
