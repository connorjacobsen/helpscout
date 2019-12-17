# frozen_string_literal: true

module HelpScout
  module API
    module Update
      module ClassMethods
        def update(id, params = {}, opts = {})
          r, _opts = request(:patch, "#{resource_url}/#{id}", params, opts)
          HelpScout::Response.new(r, object: self::OBJECT_NAME)
        end
      end

      def self.included(mod)
        mod.extend(ClassMethods)
      end
    end
  end
end
