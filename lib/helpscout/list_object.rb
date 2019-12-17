# frozen_string_literal: true

module HelpScout
  class ListObject
    include Enumerable

    attr_reader :links

    def initialize(items = [], links = [])
      @items = items
      @links = links
    end

    def each(&blk)
      @items.each(&blk)
    end
  end
end
