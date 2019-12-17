# frozen_string_literal: true

module HelpScout
  class Object
    include Enumerable

    attr_reader :id

    def self.from(values = {}, opts = {})
      # Don't mutate the data we were passed.
      values = values.dup

      id = values.delete(:id)
      new(id).send(:initialize_from, values, opts)
    end

    def initialize(id = nil, opts = {})
      @id = id
      @opts = opts

      @original_values = {}
      @unsaved_values = Set.new
      @values = {}
    end

    def [](key)
      @values[key.to_sym]
    end

    def []=(key, value)
      send(:"#{key}=", value)
    end

    def ==(other)
      other.is_a?(HelpScout::Object) &&
        @values == other.instance_variable_get(:@values)
    end

    def eql?(other)
      self == other
    end

    def keys
      @values.keys
    end

    def values
      @values.values
    end

    def each(&blk)
      @values.each(&blk)
    end

    def inspect
      id_string = respond_to?(:id) && !id.nil? ? " id=#{id}" : ''
      "#<#{self.class}:0x#{object_id.to_s(16)}#{id_string} JSON: " +
        JSON.pretty_generate(@values)
    end

    def self.deep_copy(obj)
      case obj
      when Array
        obj.map { |i| deep_copy(i) }
      when Hash
        obj.each_with_object({}) do |(k, v), copy|
          copy[k] = deep_copy(v)
          copy
        end
      when HelpScout::Object
        obj.class.from(
          deep_copy(obj.instance_variable_get(:@values)),
          obj.instance_variable_get(:@opts)
        )
      else
        obj
      end
    end

    protected

    def initialize_from(values, _opts, _partial = false)
      values = values.each_with_object({}) do |(k, v), acc|
        acc[Util.underscore(k.to_s).to_sym] = Util.to_object(v)
        acc
      end
      @original_values = self.class.deep_copy(values)
      @values = values

      add_accessors(values.keys, values)
      # TODO: handle removed values?

      self
    end

    def add_accessors(keys, values)
      self.class.instance_eval do
        keys.each do |k|
          define_method(k) { @values[k] }

          define_method(:"#{k}=") do |v|
            @values[k] = Util.to_object(v)
            @unsaved_values.add(k)
          end

          if [FalseClass, TrueClass].include?(values[k].class)
            define_method(:"#{k}?") { @values[k] }
          end
        end
      end
    end
  end
end
