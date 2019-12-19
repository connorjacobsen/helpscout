# frozen_string_literal: true

module Helpscout
  class User < Helpscout::Resource
    include Helpscout::API::Retrieve
    include Helpscout::API::List

    OBJECT_NAME = 'user'

    custom_collection_method :retrieve_resource_owner, http_verb: :get, http_path: 'me'
  end
end
