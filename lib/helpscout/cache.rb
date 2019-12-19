# frozen_string_literal: true

module Helpscout
  # Abstract class that defines the Cache interface.
  class Cache
    private_class_method :new

    def set(_key, _expiry, _value)
      raise NotImplementedError, "#{inspect}.set not implemented"
    end

    def get(_key)
      raise NotImplementedError, "#{inspect}.get not implemented"
    end
  end
end
