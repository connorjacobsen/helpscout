# frozen_string_literal: true

module Helpscout
  class Tag < Helpscout::Resource
    include Helpscout::API::List

    OBJECT_NAME = 'tag'
  end
end
