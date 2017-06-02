module Jasonette
  module Helpers
    def jason_builder property_name=nil, context=nil, &block
      klass = Jasonette::Jason.new("").klass_for_property property_name

      builder = builder(klass, context, &block)
      if ::Kernel.block_given?
        builder
      else
        BlockBuilder.new builder
      end
    end

    class BlockBuilder
      attr_reader :builder
      def initialize builder
        @builder = builder
      end

      def method_missing name, *args, &block
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

    def builder klass, context, &block
      klass.new(context || self, &block)
    end
  end
end