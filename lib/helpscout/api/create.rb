# frozen_string_literal: true

module HelpScout
  module API
    module Create
      module ClassMethods
        def create(params = {}, opts = {})
          r, _opts = request(:post, resource_url, params, opts)
          HelpScout::Response.new(r, object: self::OBJECT_NAME)
        end
      end

      def self.included(mod)
        mod.extend(ClassMethods)
      end
    end
  end
end
