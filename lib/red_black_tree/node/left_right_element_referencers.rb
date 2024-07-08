# frozen_string_literal: true

class RedBlackTree
  class Node
    module LeftRightElementReferencers # @private
      def [] direction
        case direction
        when Node::LEFT then @left
        when Node::RIGHT then @right
        else raise ArgumentError, "Direction must be one of #{DIRECTIONS}"
        end
      end

      def []= direction, node
        case direction
        when Node::LEFT then @left = node
        when Node::RIGHT then @right = node
        else raise ArgumentError, "Direction must be one of #{DIRECTIONS}"
        end
      end
    end
  end
end
