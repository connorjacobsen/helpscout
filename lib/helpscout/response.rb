# frozen_string_literal: true

module HelpScout
  class Response
    LOCATION_HEADER = 'location'
    RESOURCE_ID_HEADER = 'resource-id'

    attr_reader :status, :body, :parsed_body, :links, :result, :errors

    def initialize(response, opts = {})
      @response = response
      @is_list = opts[:is_list] || false
      @status = response.status
      @body = response.body
      @parsed_body =
        begin
          JSON.parse(@body, symbolize_names: true)
        rescue StandardError
          {}
        end

      @links = build_links(parsed_body[:_links])
      @pagination = parsed_body[:page]

      object_name = opts[:object]
      @klass = HelpScout::Types.object_by_name(object_name) || HelpScout::Object

      if success?
        @result = handle_success
      else
        @errors = handle_error
      end
    end

    def success?
      status >= 200 && status <= 399
    end

    def raw_response
      @response
    end

    private

    def handle_success
      return handle_create_or_update if status != 200

      if @is_list
        objects = @parsed_body[:_embedded].flat_map do |_key, value|
          value.map { |item| @klass.from(item) }
        end

        ListObject.new(objects, @links, @pagination)
      else
        @klass.from(@parsed_body)
      end
    end

    def handle_create_or_update
      case status
      when 201
        id = @response.headers[RESOURCE_ID_HEADER]
        @result = @klass.new(id.to_i)
      when 301
        # TODO: fetch the moved conversation
        url = URI(@response.headers[LOCATION_HEADER])
      end
    end

    def handle_error
      HelpScout::Errors.new(
        @parsed_body[:message],
        @parsed_body[:logRef],
        @parsed_body.dig(:_embedded, :errors)
      )
    end

    # `links` is the value of the `"_links"` key in the JSON response.
    def build_links(links)
      return [] if links.nil?

      links.map { |k, v| HelpScout::Link.new(Util.underscore(k.to_s).to_sym, v[:href]) }
    end
  end
end
