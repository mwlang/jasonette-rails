module Jasonette
  class Item < Jasonette::Base
    property :action
    property :style

    def badge caption=nil
      item = self.class.new(context) do
        text caption unless caption.nil?
        encode(&::Proc.new) if block_given?
      end
      append item, "badge"
    end

    private
    def append builder, msg
      @attributes[msg] ||= {}
      @attributes[msg].merge! builder.attributes!
      builder
    end
  end
end