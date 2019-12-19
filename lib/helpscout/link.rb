# frozen_string_literal: true

module Helpscout
  class Link
    attr_reader :name, :href

    def initialize(name, href, templated = false)
      @name = name
      @href = href
      @templated = templated
    end

    def templated?
      @templated
    end
  end
end
