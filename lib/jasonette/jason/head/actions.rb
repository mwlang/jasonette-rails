module Jasonette
  class Jason::Head::Actions < Jasonette::Base
      property :options
    attr_accessor :target_name

    def success &block
      item = self.class.new(@context) do
        with_attributes do
          instance_eval(&block)
        end
      end
      append item, "success"
    end

    def error &block
      item = self.class.new(@context) do
        with_attributes do
          instance_eval(&block)
        end
      end
      append item, "error"
    end

    def attributes!
      super
      if target_name
        @attributes[target_name] ||= {}
        @attributes[target_name]['options'] = options.attributes! if !options.attributes!.empty?

        target = @attributes.delete(target_name)
        without_target = @attributes
        @attributes = {}
        @attributes[target_name] = without_target.merge(target)
      else
        @attributes['options'] = options.attributes! if !options.attributes!.empty?
      end

      @attributes
    end

    private
    def append builder, msg
      if target_name
        @attributes[target_name] ||= {}
        @attributes[target_name][msg] ||= {}
        @attributes[target_name][msg].merge! builder.attributes!
      end
    end
  end
end
