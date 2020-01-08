# frozen_string_literal: true

module HelpScout
  class Link
    # @return [String, Symbol] the identifier for the Link
    attr_reader :name

    # @return the URL to which the Link points
    attr_reader :href

    # Initialize a new Link instance.
    #
    # @param name [String, Symbol] the identifier for the Link
    # @param href [String] the URL for the link
    # @param templated [Boolean] whether or not the link is templated
    def initialize(name, href, templated = false)
      @name = name
      @href = href
      @templated = templated
    end

    # Predicate function denoting whether or not the Link url
    # is a template.
    # @return [Boolean] whether or not the link is templated
    def templated?
      @templated
    end
  end
end
