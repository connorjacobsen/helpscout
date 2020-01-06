# frozen_string_literal: true

require 'forwardable'

module HelpScout
  class ListObject
    include Enumerable
    extend Forwardable

    attr_reader :links

    def initialize(items = [], links = [])
      @items = items
      @links = links
    end

    def each(&blk)
      @items.each(&blk)
    end

    def_delegators :@items, :[], :last, :take
  end
end
