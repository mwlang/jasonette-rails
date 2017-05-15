module Jasonette
  class Base
    include Properties

    class << self
      attr_accessor :template_lookup_options
    end
    self.template_lookup_options = { handlers: [:jasonette] }

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
            set! name, *args if args.present?
          end
        end
      end
    end

    attr_reader :context
    attr_reader :attributes

    def initialize context
      @context = context
      @attributes = {}

      self.extend ContexEmbedder if @context.present?
      instance_eval(&::Proc.new) if ::Kernel.block_given?
    end

    def target!
      ::MultiJson.dump attributes!
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

    def inline json
      @attributes.merge! JSON.parse(json)
      self
    end

    def partial! *args
      _render_explicit_partial(*args)
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

    # TODO : Make Base independent from Template. Its only used in `merge!`
    def j
      JasonSingleton.fetch(context)
    end

    def merge! key
      case key
      when ActiveSupport::SafeBuffer
        values = ::MultiJson.load(key) || {}
        if template = j.get_view_template(values["_template"])
          options = { locals: j.locals, template: template.virtual_path }
          _render_partial_with_options options
        end
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

    def _render_explicit_partial(name_or_options, locals = {})
      case name_or_options
        when ::Hash
          # partial! partial: 'name', foo: 'bar'
          options = name_or_options
        else
          # partial! 'name', locals: {foo: 'bar'}
          if locals.one? && (locals.keys.first == :locals)
            options = locals.merge(partial: name_or_options)
          else
            options = { partial: name_or_options, locals: locals }
          end
          # partial! 'name', foo: 'bar'
          # TODO : Add feature for option :as and :collection
          # as = locals.delete(:as)
          # options[:as] = as if as.present?
          # options[:collection] = locals[:collection] if locals.key?(:collection)
      end

      _render_partial_with_options options
    end

    def _render_partial_with_options(options)
      options.reverse_merge! locals: {}
      options.reverse_merge! Jasonette::Base.template_lookup_options
      _render_partial options
    end

    def _render_partial(options)
      options[:locals].merge! _jasonette_handler: self
      context.render options
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
