module Jasonette
  class Action < Jasonette::Base
    property :options

    def trigger name, &block
      with_attributes do
        json.trigger name
        instance_eval(&block) if block_given?
      end
    end

    def render!
      with_attributes { json.type "$render" }
    end

    def reload!
      with_attributes { json.type "$reload" }
    end

    def success &block
      item = Jasonette::Action.new(@context) do
        with_attributes do
          if block_given?
            instance_eval(&block)
          else
            json.type "$render"
          end
        end
      end
      append item, "success"
      self
    end

    def error &block
      item = Jasonette::Action.new(@context) do
        with_attributes do
          instance_eval(&block)
        end
      end
      append item, "error"
      self
    end

    private
    def append builder, msg
      @attributes[msg] ||= {}
      @attributes[msg].merge! builder.attributes!
    end
  end
end
