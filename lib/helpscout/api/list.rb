# frozen_string_literal: true

module HelpScout
  module API
    module List
      module ClassMethods
        def list(params = {}, opts = {})
          r, _opts = request(:get, resource_url, params, opts)
          HelpScout::Response.new(r, is_list: true, object: self::OBJECT_NAME)
        end
      end

      # @api private
      def self.included(mod)
        mod.extend(ClassMethods)
      end
    end
  end
end
