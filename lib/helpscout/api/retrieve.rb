# frozen_string_literal: true

module HelpScout
  module API
    module Retrieve
      module ClassMethods
        def retrieve(id, params = {}, opts = {})
          r, _opts = request(:get, "#{resource_url}/#{id}", params, opts)
          HelpScout::Response.new(r, object: self::OBJECT_NAME)
        end
      end

      # @api private
      def self.included(mod)
        mod.extend(ClassMethods)
      end
    end
  end
end
