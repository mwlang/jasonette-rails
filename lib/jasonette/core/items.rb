module Jasonette
  class Items < Jasonette::Base

    def label caption=nil, skip_type=false
      item = Jasonette::Item.new(@context) do
        text caption unless caption.nil?
        type "label" unless skip_type
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def text caption=nil, skip_type=false
      item = Jasonette::Item.new(@context) do
        text caption unless caption.nil?
        type "text" unless skip_type
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def video uri=nil, skip_type=false
      item = Jasonette::Item.new(@context) do
        type "video" unless skip_type
        file_url uri unless uri.nil?
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def image uri=nil, skip_type=false, url_key="url"
      item = Jasonette::Item.new(@context) do
        type "image" unless skip_type
        with_attributes do
          json.set! url_key, uri unless uri.nil?
          instance_eval(&::Proc.new) if block_given?
        end
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

    def textfield name=nil, value=nil, skip_type=false
      item = Jasonette::Item.new(@context) do
        type "textfield" unless skip_type
        name name unless name.nil?
        value value unless value.nil?
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def textarea name=nil, value=nil, skip_type=false
      item = Jasonette::Item.new(@context) do
        type "textarea" unless skip_type
        name name unless name.nil?
        value value unless value.nil?
        with_attributes { instance_eval(&::Proc.new) } if block_given?
      end
      append item
    end

    def space height=nil, skip_type=false
      item = Jasonette::Item.new(@context) do
        type "space" unless skip_type
        height height unless height.nil?
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
