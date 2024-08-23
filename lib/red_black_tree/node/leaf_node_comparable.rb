# frozen_string_literal: true

class RedBlackTree
  module LeafNodeComparable # @private
    def <=> other
      if other.instance_of? ::RedBlackTree::LeafNode
        1
      else
        super
      end
    end
  end
end
