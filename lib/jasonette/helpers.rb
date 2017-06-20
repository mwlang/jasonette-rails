module Jasonette
  module Helpers
    def jason_builder property_name=nil, context=nil, &block
      builder = builder(property_name, context, &block)
      if ::Kernel.block_given?
        builder
      else
        BlockBuilder.new builder
      end
    end

    def component name, *args, &block
      builder = builder(:items, nil)
      if !builder.public_methods.include?(name)
        raise "Method `#{name}` is not defined in Builder"
      end
      new_builder = builder.public_send(name, *args)
      if ::Kernel.block_given?
        j = JasonSingleton.fetch(new_builder.context)
        j.encode(new_builder, &block)
      end
      new_builder
    end

    def layout *args, &block
      component(:layout, *args, &block)
    end

    class BlockBuilder
      attr_reader :builder
      def initialize builder
        @builder = builder
      end

      def method_missing name, *args, &block
        if !builder.public_methods.include?(name)
          raise "Method `#{name}` is not defined in Builder"
        end
        next_builder = builder.public_send name, *args
        j.encode(next_builder, &block) if ::Kernel.block_given?
        next_builder
      end

      private
      def j
        JasonSingleton.fetch(builder.context)
      end
    end

    private

    def builder property_name, context, &block
      klass = Jasonette::Jason.new("").klass_for_property property_name
      klass.new(context || self, &block)
    end
  end
end