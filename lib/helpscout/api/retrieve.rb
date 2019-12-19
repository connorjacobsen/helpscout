# frozen_string_literal: true

module Helpscout
  module API
    module Retrieve
      module ClassMethods
        def retrieve(id, params = {}, opts = {})
          r, _opts = request(:get, "#{resource_url}/#{id}", params, opts)
          Helpscout::Response.new(r, object: self::OBJECT_NAME)
        end
      end

      def self.included(mod)
        mod.extend(ClassMethods)
      end
    end
  end
end
