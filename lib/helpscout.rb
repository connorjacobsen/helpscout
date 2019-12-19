# frozen_string_literal: true

require 'securerandom'

require 'json'
require 'moneta'
require 'faraday'

require 'helpscout/client'
require 'helpscout/errors'
require 'helpscout/link'
require 'helpscout/list_object'
require 'helpscout/object'
require 'helpscout/response'
require 'helpscout/util'
require 'helpscout/version'

# Middleware
require 'helpscout/middleware/token_auth'

# API mixins
require 'helpscout/api/request'
require 'helpscout/api/create'
require 'helpscout/api/retrieve'
require 'helpscout/api/list'
require 'helpscout/api/update'
require 'helpscout/api/delete'
require 'helpscout/api/nested_resource'

# Cache
require 'helpscout/cache'
require 'helpscout/cache/redis'

# Resources
require 'helpscout/resource'
require 'helpscout/resources/auth_token'
require 'helpscout/resources/conversation_attachment'
require 'helpscout/resources/conversation_field'
require 'helpscout/resources/conversation_thread'
require 'helpscout/resources/conversation'
require 'helpscout/resources/customer_address'
require 'helpscout/resources/customer_chat'
require 'helpscout/resources/customer_email'
require 'helpscout/resources/customer_phone'
require 'helpscout/resources/customer_social_profile'
require 'helpscout/resources/customer_website'
require 'helpscout/resources/customer'
require 'helpscout/resources/mailbox_field'
require 'helpscout/resources/mailbox_folder'
require 'helpscout/resources/mailbox'
require 'helpscout/resources/rating'
require 'helpscout/resources/tag'
require 'helpscout/resources/team'
require 'helpscout/resources/user'
require 'helpscout/resources/webhook'
require 'helpscout/resources/workflow'

require 'helpscout/types'

module Helpscout
  DEFAULT_BASE_URI = 'https://api.helpscout.net'

  @base_uri = DEFAULT_BASE_URI

  # Note: cache should be an instance.
  # TODO: figure out if that gets us into trouble.
  class << self
    attr_accessor :base_uri, :cache, :client_id, :client_secret
  end

  def self.new_client
    Helpscout::Client.new(
      base_uri: base_uri,
      cache: cache,
      client_id: client_id,
      client_secret: client_secret
    )
  end
end
