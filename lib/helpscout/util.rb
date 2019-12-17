# frozen_string_literal: true

module HelpScout
  module Util
    def self.underscore(str)
      str.gsub(/::/, '/')
         .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
         .gsub(/([a-z\d])([A-Z])/, '\1_\2')
         .tr('-', '_')
         .downcase
    end

    def self.to_object(data, opts = {})
      klass = HelpScout::Types.object_names_to_classes.fetch(opts[:object], HelpScout::Object)

      case data
      when Array
        data.map { |i| to_object(i, opts) }
      when Hash
        klass.from(data, opts)
      else
        data
      end
    end
  end
end
