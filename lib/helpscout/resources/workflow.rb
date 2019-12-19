# frozen_string_literal: true

module Helpscout
  class Workflow < Helpscout::Resource
    include Helpscout::API::List
    include Helpscout::API::Update

    OBJECT_NAME = 'workflow'
  end
end
