module Jasonette
  class Jason::Head < Jasonette::Base

    property :styles
    property :actions
    property :data
    property :templates

    def template name, *args, &block
      if block_given?
        item = Jasonette::Body.new(@context) do
          with_attributes { instance_eval(&block) }
        end
        append item, "templates", name
      else
        property_sender templates, name, *args
      end
      self
    end

    def datum name, *args, &block
      property_sender data, name, *args, &block
    end

    def style name, *args, &block
      property_sender styles, name, *args, &block
    end

    def action name, *args, &block
      if block_given?
        item = Jasonette::Action.new(@context) do
          with_attributes { instance_eval(&block) }
        end
        append item, "actions", name
      else
        property_sender actions, name, *args
      end
      self
    end

    private
    def append builder, property_name, msg
      @attributes[property_name] ||= {}
      @attributes[property_name][msg] ||= {}
      @attributes[property_name][msg].merge! builder.attributes!
    end
  end
end
