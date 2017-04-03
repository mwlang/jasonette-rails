module Jasonette
  module JbuilderExtensions
    def jason &block
      builder = Jasonette::Jason.new(@context)
      builder.with_attributes &block
      _set_value "$jason", builder.attributes!
      self
    end

    def body &block
      builder = Jasonette::Jason::Body.new(@context)
      builder.with_attributes &block
      _set_value "body", builder.attributes!
      self
    end
  end

  ::Jbuilder.send(:include, JbuilderExtensions)
end
