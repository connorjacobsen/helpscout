# frozen_string_literal: true

module HelpScout
  module API
    module NestedResource
      module ClassMethods
        def nested_resource_class_methods(resource, path: nil, operations: nil,
                                          resource_plural: nil, object_name: nil)
          resource_plural ||= "#{resource}s"
          path ||= resource_plural
          object_name ||= HelpScout::Object

          raise ArgumentError, 'operations array required' if operations.nil?

          resource_url_method = :"#{resource}s_url"

          define_singleton_method(resource_url_method) do |id, nested_id = nil|
            url = "#{resource_url}/#{id}/#{path}"
            url += "/#{nested_id}" unless nested_id.nil?
            url
          end

          operations.each do |operation|
            case operation
            when :create
              define_singleton_method("create_#{resource}") do |id, params = {}, opts = {}|
                url = send(resource_url_method, id)
                resp, _opts = request(:post, url, params, opts)
                HelpScout::Response.new(resp, object: object_name)
              end
            when :retrieve
              define_singleton_method("retrieve_#{resource}") do |id, nested_id, opts = {}|
                url = send(resource_url_method, id, nested_id)
                resp, _opts = request(:get, url, {}, opts)
                HelpScout::Response.new(resp, object: object_name)
              end
            when :list
              define_singleton_method("list_#{resource_plural}") \
                do |id, params = {}, opts = {}|
                  url = send(resource_url_method, id)
                  resp, _opts = request(:get, url, params, opts)
                  HelpScout::Response.new(resp, is_list: true, object: object_name)
                end
            when :update
              define_singleton_method("update_#{resource}") \
                do |id, nested_id, params = {}, opts = {}|
                  url = send(resource_url_method, id, nested_id)
                  resp, _opts = request(:patch, url, params, opts)
                  HelpScout::Response.new(resp, object: object_name)
                end
            when :delete
              define_singleton_method("delete_#{resource}") do |id, nested_id, opts = {}|
                url = send(resource_url_method, id, nested_id)
                resp, _opts = request(:delete, url, {}, opts)
                HelpScout::Response.new(resp, object: object_name)
              end
            else
              raise ArgumentError, "Unknown operation: #{operation.inspect}"
            end
          end
        end
      end

      # @api private
      def self.included(mod)
        mod.extend(ClassMethods)
      end
    end
  end
end
