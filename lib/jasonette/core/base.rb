module Jasonette
  class Base
    include Properties

    def implicit_set! name, *args, &block
      if property_names.include? name
        with_attributes { property_set! name, *args, &block }
      else
        set!(name) { encode(&block) }
      end
    end

    def attr_value name
      if property_names.include? name
        instance_variable_get :"@#{name}"
      else
        @attributes[name.to_s]
      end
    end

    def method_missing name, *args, &block
      if ::Kernel.block_given?
        implicit_set! name, *args, &block
      else
        if property_names.include? name
          return property_get! name
        else
          set! name, *args if args.present?
        end
      end
    end

    attr_reader :context
    attr_reader :attributes

    def initialize context
      @context = context
      @attributes = {}

      encode(&::Proc.new) if ::Kernel.block_given?
    end

    # Fixed for below error :
    # IOError - not opened for reading:
    # activesupport (5.0.1) lib/active_support/core_ext/object/json.rb:130:in `as_json'
    # Eventually called by multi_json/adapter.rb:25:in `dump'
    def as_json(options = nil)
      attributes!
    end

    def encode
      binding = eval "self", ::Proc.new.binding
      if (binding.method(:encode).parameters.first.include?(:req) rescue false)
        binding.encode(self, &::Proc.new)
      else
        instance_eval(&::Proc.new)
      end
      self
    end

    def empty?
      properties_empty? && @attributes.empty?
    end

    def klass name
      set! "class", name
    end
    alias :css_class :klass

    def _method name = nil
      if block_given?
        set! 'method', _scope { yield }
      else
        set! 'method', name
      end
    end
    alias :action_method :_method

    def with_attributes
      @attributes.merge! _scope { yield self }
      self
    end

    def inline json
      @attributes.merge! JSON.parse(json)
      self
    end

    def attributes!
      merge_properties
      @attributes
    end

    def set! key, value=nil, *args
      result = if ::Kernel.block_given?
        if !_blank?(value)
          # comments @post.comments { |comment| ... }
          # { "comments": [ { ... }, { ... } ] }
          _scope{ array! value, &::Proc.new }
        else
          # comments { ... }
          # { "comments": ... }
          _merge_block(key){ yield self }
        end
      elsif args.empty?
        if _is_collection?(value) || Jasonette::Base === value
          # person another_jasonette
          # { "person": { ...  } }
          # comments [ { content: "...", created_at: "..." } ]
          # { "comments": [ { "content": "hello", "created_at": "..." } ] }
          # comments { content: "...", created_at: "..." }
          # { "comments": [ { "content": "hello", "created_at": "..." } ] }
          _scope{ merge! value }
        else
          _key(value)
        end
      elsif _is_collection?(value)
        # comments @post.comments, :content, :created_at
        # { "comments": [ { "content": "hello", "created_at": "..." }, { "content": "world", "created_at": "..." } ] }
        _scope{ array! value, *args }
      else
        # author @post.creator, :name, :email_address
        # { "author": { "name": "David", "email_address": "david@loudthinking.com" } }
        _merge_block(key){ extract! value, *args }
      end

      _set_key_value key, result
      self
    end


    def array! collection = [], *args
      array = if collection.nil?
        []
      elsif ::Kernel.block_given?
        _map_collection(collection, &::Proc.new)
      else
        _map_collection(collection) { |element| extract! element, *args }
      end

      merge! array
    end

    def extract! object, *attributes
      if ::Hash === object
        _extract_hash_values(object, attributes)
      elsif Jasonette::Base === object
        _extract_hash_values(object.attributes!, attributes)
      else
        _extract_method_values(object, attributes)
      end
    end

    def merge! key
      case key
      when Jasonette::Base
        merge! key.attributes! 
      when Hash
        key.each{ |key, value| set! _key(key), value }
      when Array
        _set_value key
      end
      @attributes
    end

    private

    def _extract_hash_values(object, attributes)
      if attributes.blank?
        object.each{ |key, value| _set_key_value key, value }
      else
        attributes.each{ |key| _set_key_value key, object.fetch(key) }
      end
    end

    def _extract_method_values(object, attributes)
      if attributes.blank?
        _set_value object
      else
        attributes.each{ |key| _set_key_value key, object.public_send(key) }
      end
    end

    def _merge_block(key)
      current_value = @attributes.fetch(_key(key), {})
      new_value = _scope{ yield self }
      _merge_values(current_value, new_value)
    end

    def _merge_values(current_value, updates)
      if _blank?(updates)
        current_value
      elsif _blank?(current_value) || updates.nil? || current_value.empty? && ::Array === updates
        updates
      elsif ::Array === current_value && ::Array === updates
        current_value + updates
      elsif ::Hash === current_value && ::Hash === updates
        current_value.merge(updates)
      else
        raise "MergeError"
      end
    end

    def _key(key)
      key.to_s
    end

    def _set_key_value(key, value)
      raise "ArrayError" if ::Array === @attributes
      @attributes[_key(key)] = value unless _blank?(value)
    end

    def _set_value(value)
      raise "HashError" if ::Hash === @attributes && !_blank?
      @attributes = value unless _blank?(value)
    end

    def _map_collection(collection)
      collection.map do |element|
        _scope{ yield element }
      end # - [BLANK]
    end

    def _scope
      parent_attributes = @attributes
      @attributes = {}
      yield
      @attributes
    ensure
      @attributes = parent_attributes
    end

    def _is_collection?(object)
      _object_respond_to?(object, :map, :count) # && NON_ENUMERABLES.none?{ |klass| klass === object }
    end

    def _blank?(value=@attributes)
      value.nil? ? true : value.blank?
    end

    def _object_respond_to?(object, *methods)
      methods.all?{ |m| object.respond_to?(m) }
    end
  end
end
