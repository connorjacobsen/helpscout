# frozen_string_literal: true

module Helpscout
  class Rating < Helpscout::Resource
    include Helpscout::API::Retrieve

    OBJECT_NAME = 'rating'
  end
end
