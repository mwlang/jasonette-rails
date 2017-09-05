module Jasonette
  class Body::Header < Jasonette::Base
    property :style
    property :search

    def menu caption=nil, image_uri=nil
      item = Jasonette::Item.new(context) do
        text caption unless caption.nil?
        image image_uri unless image_uri.nil?
        encode(&::Proc.new) if block_given?
      end
      append item, "menu"
    end

    private
    def append builder, msg
      @attributes[msg] ||= {}
      @attributes[msg].merge! builder.attributes!
      builder
    end
  end
end
