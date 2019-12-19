# frozen_string_literal: true

module Helpscout
  module Middleware
    # Request middleware for fetching Helpscout credentials.
    class TokenAuth < Faraday::Middleware
      AUTH_HEADER = 'authorization'
      CACHE_KEY = 'helpscout-auth-token'

      # Store tokens for 100m. They expire after 120m.
      EXPIRY = 6_000

      def initialize(app, cache: nil, expiry: EXPIRY)
        super(app)
        @cache = cache
        @expiry = expiry
      end

      # @param env [Faraday::Env]
      def call(env)
        # Hack to skip this when we are requesting an auth token.
        unless env.url.path == Helpscout::AuthToken::PATH
          env[:request_headers][AUTH_HEADER] = "Bearer #{auth_token}"
        end

        @app.call(env)
      end

      private

      def auth_token
        if @cache&.key?(CACHE_KEY)
          @cache.load(CACHE_KEY)
        else
          fetch_auth_token
        end
      end

      def fetch_auth_token
        resp, _opts = Helpscout::AuthToken.create
        outcome = Helpscout::Response.new(resp)

        unless outcome.success?
          raise Helpscout::ClientError, 'Failed to fetch OAuth2 access token'
        end

        outcome.result.access_token.tap do |token|
          @cache.store(CACHE_KEY, token, expiry: @expiry) if @cache
        end
      end
    end
  end
end
