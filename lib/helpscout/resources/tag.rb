# frozen_string_literal: true

module HelpScout
  class Tag < HelpScout::Resource
    include HelpScout::API::List

    OBJECT_NAME = 'tag'
  end
end
