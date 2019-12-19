# frozen_string_literal: true

module Helpscout
  class Error < StandardError; end
  class ClientError < Error; end

  ResponseError = Struct.new(:path, :message, :source, :rejected_value)

  class Errors
    attr_reader :message, :log_ref, :errors

    def initialize(message, log_ref, errors)
      @message = message
      @log_ref = log_ref
      @errors = build_errors(errors)
    end

    private

    def build_errors(errors)
      return [] if errors.nil?

      errors.map do |e|
        ResponseError.new(e[:path], e[:message], e[:source], e[:rejected_value])
      end
    end
  end
end
