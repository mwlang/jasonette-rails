module Jasonette
  class Items < Jasonette::Base

    def label caption=nil
      item = Jasonette::Base.new(@context) do
        text caption unless caption.nil?
        type "label"
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def image uri=nil
      item = Jasonette::Base.new(@context) do
        type "image"
        url uri unless uri.nil?
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def layout orientation="vertical"
      item = Jasonette::Layout.new(@context) do
        type orientation
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    private

    def append builder
      @attributes["items"] ||= []
      @attributes["items"] << builder.attributes!
      self
    end
  
  end
end
