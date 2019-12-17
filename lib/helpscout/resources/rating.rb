# frozen_string_literal: true

module HelpScout
  class Rating < HelpScout::Resource
    include HelpScout::API::Retrieve

    OBJECT_NAME = 'rating'
  end
end
