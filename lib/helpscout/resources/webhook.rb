# frozen_string_literal: true

module Helpscout
  class Webhook < Helpscout::Resource
    include Helpscout::API::Retrieve
    include Helpscout::API::List
    include Helpscout::API::Create
    include Helpscout::API::Update
    include Helpscout::API::Delete

    OBJECT_NAME = 'webhook'
  end
end
