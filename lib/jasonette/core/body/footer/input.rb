module Jasonette
  class Body::Footer::Input < Jasonette::Base
    property :style

    def left uri=nil, &block
      append Jasonette::Items.new(context).image(uri, true, &block), "left"
    end

    def right caption=nil, &block
      append Jasonette::Items.new(context).label(caption, true, &block), "right"
    end

    def textfield name=nil, value=nil, &block
      append Jasonette::Items.new(context).textfield(name, value, true, &block), "textfield"
    end

    private
    def append builder, msg
      @attributes[msg] ||= {}
      @attributes[msg].merge! builder.attributes!
      builder
    end
  end
end