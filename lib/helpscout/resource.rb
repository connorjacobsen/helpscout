# frozen_string_literal: true

module HelpScout
  class Resource < HelpScout::Object
    extend HelpScout::API::Request

    def self.class_name
      name.split('::')[-1]
    end

    def self.resource_url
      "/v2/#{plural}"
    end

    def self.plural
      "#{self::OBJECT_NAME.downcase.tr('.', '/')}s"
    end

    def self.update_verb
      :patch
    end

    def self.custom_resource_method(name, http_verb:, http_path: nil, object_name: nil)
      unless %i[get post patch put delete].include?(http_verb)
        raise ArgumentError,
              "Invalid http_verb value: #{http_verb.inspect}. Should be one " \
              'of :get, :post, :put, :patch, or :delete.'
      end

      http_path ||= name.to_s
      object_name ||= self::OBJECT_NAME

      define_singleton_method(name) do |id, params = {}, opts = {}|
        url = "#{resource_url}/#{id}/#{http_path}"
        resp, _opts = request(http_verb, url, params, opts)
        HelpScout::Response.new(resp, object: object_name)
      end
    end

    def self.custom_collection_method(name, http_verb:, http_path: nil, object_name: nil)
      unless %i[get post patch put delete].include?(http_verb)
        raise ArgumentError,
              "Invalid http_verb value: #{http_verb.inspect}. Should be one " \
              'of :get, :post, :put, :patch, or :delete.'
      end

      http_path ||= name.to_s
      object_name ||= self::OBJECT_NAME

      define_singleton_method(name) do |params = {}, opts = {}|
        url = "#{resource_url}/#{http_path}"
        resp, _opts = request(http_verb, url, params, opts)
        HelpScout::Response.new(resp, object: object_name)
      end
    end
  end
end
