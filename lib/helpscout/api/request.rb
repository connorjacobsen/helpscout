# frozen_string_literal: true

module HelpScout
  module API
    module Request
      def request(method, url, params = {}, opts = {})
        # Generate new client
        client = HelpScout.new_client
        additional_headers = opts[:headers] || {}
        headers = HelpScout::Client::DEFAULT_HEADERS.merge(additional_headers)

        resp = client.execute_request(method, url, headers: headers, params: params)
        [resp, opts]
      end
    end
  end
end
