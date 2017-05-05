module Jasonette
  class Base
    include Properties
    # include ActionView::Helpers

    def implicit_set! name, *args, &block
      if property_names.include? name
        with_attributes { property_set! name, *args, &block }
      else
        begin
          return context_method(name, *args, &block)
        rescue
          set!(name) { instance_eval(&block) }
        end
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
          begin
            return context_method(name, *args, &block)
          rescue
            set! name, *args
          end
        end
      end
    end

    attr_reader :context
    attr_reader :attributes

    def initialize context
      @context = context
      @attributes = {}

      # self.extend ContexEmbedder if @context.present?
      instance_eval(&::Proc.new) if ::Kernel.block_given?
    end

    def target!
      attributes!.to_json
    end

    def encode
      instance_eval(&::Proc.new)
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

    # def with_partial_attributes pjson, &block
    #   new_parent_builder = self.class.new(context)
    #   new_parent_builder.with_attributes { instance_eval(&block) }
    #   new_parent_builder.attributes!.each do |k, v|
    #     with_attributes do
    #       set! k, (@attributes[k] ? @attributes[k].merge(v) : v)
    #     end
    #   end
    # end

    def inline json
      @attributes.merge! JSON.parse(json)
      self
    end

    # If partial is built as Jbuilder style then partial! is called as example given below.
    #
    # Example:
    #   json.jason do
    #     partial! "foo/partial", built_as: :json
    #   end
    # def partial! name, options = {}
    #   built_as = options.delete(:built_as)
    #   if built_as && built_as == :json
    #     with_attributes { json.partial! name, options }
    #   else
    #     JbuilderTemplate.new(context) do |json|
    #       json.partial_lookup_options = {}
    #       json.partial_lookup_options[:handler] = self
    #       json.partial! name, options
    #     end
    #   end
    # end
    #
    # def inline! name, *args
    #   j = JbuilderTemplate.new(context) do |json|
    #     json.partial! name, *args
    #   end
    #   @attributes.merge! j.attributes!
    #   self
    # end

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
        if Jasonette === value
          # person another_jasonette
          # { "person": { ...  } }
          value.attributes!
        elsif _is_collection?(value) && !(::Hash === value)
          # comments @post.comments [ { content: "...", created_at: "..." } ]
          # { "comments": [ { "content": "hello", "created_at": "..." } ] }
          _scope{ array! value }
        else
          value
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


    def array!(collection = [], *attributes)
      array = if collection.nil?
        []
      elsif ::Kernel.block_given?
        _map_collection(collection, &::Proc.new)
      elsif attributes.any?
        _map_collection(collection) { |element| extract! element, *attributes }
      else
        collection.to_a
      end

      merge! array
    end

    def extract!(object, *attributes)
      if ::Hash === object
        _extract_hash_values(object, attributes)
      else
        _extract_method_values(object, attributes)
      end
    end

    def merge! key
      case key
      when ActiveSupport::SafeBuffer
        # Jasonette::Template.new(context) do |json|
        #   json.partial_lookup_options = {}
        #   json.partial_lookup_options[:handler] = self
        #   json.instance_eval(MultiJson.load(key)["$jason_outflow_content"] || '')
        # end
      when Hash
        @attributes.merge! key
      when Array
        @attributes = key
      end
    end

    private

    def context_method name, *args, &block
      context.send(name, *args, &block)
    end

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
      value.nil?
    end

    def _object_respond_to?(object, *methods)
      methods.all?{ |m| object.respond_to?(m) }
    end
  end

  module ContexEmbedder
    def self.extended(klass_obj)
      context = klass_obj.context
      context.instance_variables.each do |var|
        raise "Jason is using #{var} instance variable. Please change variable name." if klass_obj.instance_variable_get(var)
        klass_obj.instance_variable_set var, context.instance_variable_get(var)
      end
    end
  end
end
