# frozen_string_literal: true

module HelpScout
  module API
    module Update
      module ClassMethods
        # @param id [String] the identifier for the resource
        # @param params [Hash] the params for the update call
        # @param opts [Hash] the options for the request (mostly unused)
        def update(id, params = {}, opts = {})
          r, _opts = request(update_verb, "#{resource_url}/#{id}", params, opts)
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
