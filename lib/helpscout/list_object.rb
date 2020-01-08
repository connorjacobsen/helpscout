# frozen_string_literal: true

require 'forwardable'

module HelpScout
  class ListObject
    include Enumerable
    extend Forwardable

    # @return [Array] the pagination Links
    attr_reader :links

    # @return [Object] the pagination information
    attr_reader :page

    def initialize(items = [], links = [], page = nil)
      @items = items
      @links = links
      @page = page ? HelpScout::Object.from(page) : nil
    end

    def each(&blk)
      @items.each(&blk)
    end

    def_delegators :@items, :[], :last, :take
  end
end
