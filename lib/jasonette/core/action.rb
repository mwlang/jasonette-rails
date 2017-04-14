module Jasonette
  class Action < Jasonette::Base
    property :options

    def success &block
      item = Jasonette::Action.new(@context) do
        with_attributes do
          instance_eval(&block)
        end
      end
      append item, "success"
    end

    def error &block
      item = Jasonette::Action.new(@context) do
        with_attributes do
          instance_eval(&block)
        end
      end
      append item, "error"
    end

    private
    def append builder, msg
      @attributes[msg] ||= {}
      @attributes[msg].merge! builder.attributes!
    end
  end
end
