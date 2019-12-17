# frozen_string_literal: true

require 'helpscout/resources/user'

module HelpScout
  class Team < HelpScout::Resource
    include HelpScout::API::List
    include HelpScout::API::NestedResource

    OBJECT_NAME = 'team'

    nested_resource_class_methods :member,
                                  operations: %i[list],
                                  object_name: HelpScout::User::OBJECT_NAME
  end
end
