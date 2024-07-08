# frozen_string_literal: true

require_relative "../node"

class RedBlackTree
  class LeafNode < Node # @private
    def initialize
      super nil

      @colour = BLACK
    end

    def <=> other
      (other.instance_of? LeafNode) ? 0 : -1
    end
  end
end
