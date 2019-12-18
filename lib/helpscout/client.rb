# frozen_string_literal: true

module HelpScout
  class Client
    attr_reader :base_uri, :cache, :client_id, :client_secret

    DEFAULT_HEADERS = {
      'content-type' => 'application/json'
    }.freeze

    # TODO: enable resetting of these values while in operation.
    #   Will require restarting any connections, etc.
    def initialize(base_uri: nil, cache:, client_id:, client_secret:, connection: nil)
      @base_uri = base_uri || HelpScout::DEFAULT_BASE_URI
      @cache = cache
      @client_id = client_id
      @client_secret = client_secret
      @connection = connection

      ensure_connection
    end

    def execute_request(method, path, headers: [], params: {})
      @connection.send(method) do |req|
        req.url(path)

        # These methods replace the connection's previous values.
        req.headers = @connection.headers.merge(headers)

        req.params = params if method == :get && !params.empty?

        if %i[post put patch].include?(method) && params && params != {}
          encoded_body = JSON.generate(params)
          req.body = encoded_body
        end
      end
    end

    private

    def ensure_connection
      return unless @connection.nil?

      # Faraday.new doesn't seem to pass in the `headers` properly.
      @connection = Faraday::Connection.new(@base_uri, headers: DEFAULT_HEADERS) do |builder|
        builder.use HelpScout::Middleware::TokenAuth

        builder.adapter :net_http
      end
    end
  end
end
