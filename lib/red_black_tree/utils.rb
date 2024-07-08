# frozen_string_literal: true

class RedBlackTree
  module Utils # @private
    private

    def opposite_direction direction
      case direction
      when "up" then "down"
      when "right" then "left"
      when "down" then "up"
      when "left" then "right"
      else raise ArgumentError, "Invalid direction"
      end
    end
  end
end
