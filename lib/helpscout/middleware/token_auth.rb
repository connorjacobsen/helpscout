# frozen_string_literal: true

module HelpScout
  module Middleware
    # Request middleware for fetching HelpScout credentials.
    class TokenAuth < Faraday::Middleware
      AUTH_HEADER = 'authorization'

      # @param env [Faraday::Env]
      def call(env)
        # Hack to skip this when we are requesting an auth token.
        unless env.url.path == HelpScout::AuthToken::PATH
          # TODO: do cache lookup first

          resp, _opts = HelpScout::AuthToken.create
          outcome = HelpScout::Response.new(resp)

          unless outcome.success?
            raise HelpScout::ClientError, 'Failed to fetch OAuth2 access token'
          end

          env[:request_headers][AUTH_HEADER] = "Bearer #{outcome.result.access_token}"
        end

        @app.call(env)
      end
    end
  end
end
