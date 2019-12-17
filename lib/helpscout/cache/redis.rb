# frozen_string_literal: true

require 'redis'

module HelpScout
  class Cache
    # Naming is a bit redundant, but allows us to avoid shadowing
    # the Redis client gem constants.
    class RedisCache < HelpScout::Cache
      public_class_method :new

      def initialize(opts)
        @redis = Redis.new(opts)
      end

      def set(key, expiry, value)
        @redis.setex(key, expiry, value)
      end

      def get(key)
        @redis.get(key)
      end
    end
  end
end
