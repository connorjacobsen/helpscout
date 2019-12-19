# frozen_string_literal: true

module Helpscout
  class AuthToken < Helpscout::Resource
    PATH = '/v2/oauth2/token'

    def self.create(params = {}, opts = {})
      request(:post, PATH, token_params(params), opts)
    end

    def self.token_params(initial_params = {})
      {
        grant_type: 'client_credentials',
        client_id: initial_params[:client_id] || Helpscout.client_id,
        client_secret: initial_params[:client_secret] || Helpscout.client_secret
      }
    end
    private_class_method :token_params
  end
end
