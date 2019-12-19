# frozen_string_literal: true

module Helpscout
  module API
    module Request
      def request(method, url, params = {}, opts = {})
        # Generate new client
        client = Helpscout.new_client
        additional_headers = opts[:headers] || {}
        headers = Helpscout::Client::DEFAULT_HEADERS.merge(additional_headers)

        resp = client.execute_request(method, url, headers: headers, params: params)
        [resp, opts]
      end
    end
  end
end
