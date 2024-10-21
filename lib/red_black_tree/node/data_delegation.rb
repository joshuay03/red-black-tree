# frozen_string_literal: true

class RedBlackTree
  module DataDelegation
    def method_missing(method_name, *args, &block)
      if @data.respond_to?(method_name)
        @data.public_send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @data.respond_to?(method_name, include_private) || super
    end
  end
end
