# frozen_string_literal: true

module Helpscout
  module API
    module Delete
      module ClassMethods
        def delete(id, opts = {})
          r, _opts = request(:delete, "#{resource_url}/#{id}", {}, opts)
          Helpscout::Response.new(r, object: self::OBJECT_NAME)
        end
      end

      def self.included(mod)
        mod.extend(ClassMethods)
      end
    end
  end
end
