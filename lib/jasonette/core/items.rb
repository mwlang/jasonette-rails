module Jasonette
  class Items < Jasonette::Base

    def label caption=nil, with_type = true
      item = Jasonette::Item.new(@context) do
        text caption unless caption.nil?
        type "label" if with_type
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def text caption=nil, with_type = true
      item = Jasonette::Item.new(@context) do
        text caption unless caption.nil?
        type "text" if with_type
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def video uri=nil, with_type = true
      item = Jasonette::Item.new(@context) do
        type "video" if with_type
        file_url uri unless uri.nil?
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def image uri=nil, with_type = true
      item = Jasonette::Item.new(@context) do
        type "image" if with_type
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

    def textfield name=nil, value=nil, with_type = true
      item = Jasonette::Item.new(@context) do
        type "textfield" if with_type
        name name unless name.nil?
        value value unless value.nil?
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def textarea name=nil, value=nil, with_type = true
      item = Jasonette::Item.new(@context) do
        type "textarea" if with_type
        name name unless name.nil?
        value value unless value.nil?
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    private

    def append builder
      @attributes["items"] ||= []
      @attributes["items"] << builder.attributes!
      builder
    end
  
  end
end
