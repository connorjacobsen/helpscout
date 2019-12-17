# frozen_string_literal: true

module HelpScout
  class Webhook < HelpScout::Resource
    include HelpScout::API::Retrieve
    include HelpScout::API::List
    include HelpScout::API::Create
    include HelpScout::API::Update
    include HelpScout::API::Delete

    OBJECT_NAME = 'webhook'
  end
end
