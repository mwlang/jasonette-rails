module Jasonette

  class JasonSingleton
    private_class_method :new
    @@instances = []

    def self.fetch context
      if instance = find(context)
        instance
      else
        instance = Jasonette::Template.new(context)
        @@instances << instance
        instance
      end
    end

    def self.find context
      @@instances.select { |instance| instance.context == context }.first
    end

    def self.reset context
      if instance = find(context)
        instances.delete_if { |i| i == instance }
      end
    end

    def self.instances
      @@instances
    end
  end

  class Template
    class << self
      attr_accessor :template_lookup_options

      def load context
        JasonSingleton.fetch context
      end
    end
    self.template_lookup_options = { handlers: [:jasonette] }

    def method_missing name, *args, &block
      if _last_builder
        if _last_builder.property_names.include? name
          _last_builder.public_send name, *args, &block
        else
          begin
            if _last_builder.public_methods.include?(name)
              _last_builder.public_send name, *args, &block
            else
              context_method name, *args, &block
            end
          rescue
            _last_builder.public_send name, *args, &block
          end
        end
      else
        context_method name, *args, &block
      end
    end

    attr_accessor :__layout, :__locals
    attr_reader   :context, :attributes

    def initialize context
      @context = context
      @attributes = {}
      @blocks = []
      self.extend ContexEmbedder if @context.present?
    end

    def has_layout? template_id
      template = _get_view_template(template_id)
      _layout_path && _layout_path != template.virtual_path
    end

    def new_jason template_id
      new_jason = self.class.new context
      new_jason.attributes["_template"] = "#{template_id}"
      new_jason
    end

    def encode builder, &block
      if ::Kernel.block_given?
        @blocks << block
        block.instance_variable_set("@builder", builder)
        instance_eval(&block)
        @blocks.delete(block)
      else
        raise "Wrong encode"
      end
      self
    end

    def jason name=nil, &block
      builder = Jasonette::Jason.new(context)
      encode(builder, &block)
      @attributes[name || "$jason"] = builder.attributes!
      JasonSingleton.reset context
      self
    end
    alias build jason

    def attributes!
      @attributes
    end

    def target!
      ::MultiJson.dump attributes!
    end

    def set! name, object = nil, *args
      super
    end

    def array! collection = [], *args
      super
    end

    def extract! object, *attributes
      super
    end

    def merge! key
      case key
      when ActiveSupport::SafeBuffer
        values = ::MultiJson.load(key) || {}

        if template = _get_view_template(values["_template"])
          options = { locals: __locals, template: template.virtual_path }
          _render_partial_with_options options
        end
      else
        super
      end
      @attributes
    end

    def partial! *args
      _render_explicit_partial(*args)
    end

    private

    def context_method name, *args, &block
      context.public_send(name, *args, &block)
    end

    def _last_builder
      @blocks.last.instance_variable_get("@builder")
    end

    def _layout_path
      __layout && __layout.try(:virtual_path)
    end

    def _get_view_template template_id
      ObjectSpace._id2ref(template_id.to_i)
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
      options.reverse_merge! self.class.template_lookup_options

      _render_partial options
    end

    def _render_partial(options)
      options[:locals].merge! _jasonette_handler: _last_builder
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
