# frozen_string_literal: true

module HelpScout
  class User < HelpScout::Resource
    include HelpScout::API::Retrieve
    include HelpScout::API::List

    OBJECT_NAME = 'user'

    custom_collection_method :retrieve_resource_owner, http_verb: :get, http_path: 'me'
  end
end
