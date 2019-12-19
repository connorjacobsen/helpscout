# frozen_string_literal: true

require 'helpscout/resources/user'

module Helpscout
  class Team < Helpscout::Resource
    include Helpscout::API::List
    include Helpscout::API::NestedResource

    OBJECT_NAME = 'team'

    nested_resource_class_methods :member,
                                  operations: %i[list],
                                  object_name: Helpscout::User::OBJECT_NAME
  end
end
