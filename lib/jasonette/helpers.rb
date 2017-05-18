module Jasonette
  module Helpers
    def jason_builder property_name=nil, context=nil, &block
      klass = Jasonette::Jason.new("").klass_for_property property_name
      builder(klass, context, &block)
    end

    private

    def builder klass, context, &block
      klass.new(context || self, &block)
    end
  end
end