# frozen_string_literal: true

module HelpScout
  class Workflow < HelpScout::Resource
    include HelpScout::API::List
    include HelpScout::API::Update

    OBJECT_NAME = 'workflow'
  end
end
