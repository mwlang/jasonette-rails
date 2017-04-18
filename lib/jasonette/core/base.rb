module Jasonette
  class Base
    include Properties
    include ActionView::Helpers

    def implicit_set! name, *args, &block
      with_attributes do
        if properties.include? name
          property_set! name, *args, &block
        else
          json.set!(name) { instance_eval(&block) }
        end
      end
    end

    def attr_value name
      if properties.include? name
        instance_variable_get :"@#{name}"
      else
        @attributes[name.to_s]
      end
    end

    def method_missing name, *args, &block
      if ::Kernel.block_given?
        implicit_set! name, *args, &block
      else
        if properties.include? name
          return property_get! name
        else
          with_attributes { json.set! name, *args }
        end
      end
      self
    end

    attr_reader :context
    attr_reader :attributes
    attr_reader :json

    def initialize context
      @context = context
      @attributes = {}

      self.extend ContexEmbedder if @context.present?
      instance_eval(&::Proc.new) if ::Kernel.block_given?
    end

    def trigger name, &block
      with_attributes do
        json.trigger name
        instance_eval(&block) if block_given?
      end
    end

    def action name="action", &block
      with_attributes do
        json.set! name do
          block_given? ? instance_eval(&block) : success { type "$render" }
        end
      end
    end

    def render!
      with_attributes { json.type "$render" }
    end

    def reload!
      with_attributes { json.type "$reload" }
    end

    def success &block
      with_attributes do
        if block_given?
          json.success { instance_eval(&block) }
        else
          json.success { json.type "$render" }
        end
      end
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
      json.set! "class", name
    end
    alias :css_class :klass

    def with_attributes
      if json
        instance_eval(&::Proc.new)
        return self
      end
      template = JbuilderTemplate.new(context) do |json|
        @json = json
        instance_eval(&::Proc.new)
        @json = nil
      end
      @attributes.merge! template.attributes!
      self
    end

    def inline json
      @attributes.merge! JSON.parse(json)
      self
    end

    def partial! name, *args
      with_attributes { json.partial! name, *args }
    end

    def inline! name, *args
      j = JbuilderTemplate.new(context) do |json|
        json.partial! name, *args
      end
      @attributes.merge! j.attributes!
      self
    end

    def attributes!
      merge_properties
      @attributes
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
