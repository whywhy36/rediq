require 'forwardable'

module Rediq
  class Worker
    extend Forwardable

    attr_accessor :labour

    def_delegators :@labour, :handle

    def initialize(labour)
      @labour = labour
      yield self if block_given?
    end
  end
end