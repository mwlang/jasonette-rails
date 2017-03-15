module Jasonette
  class Jason::Head < Jasonette::Base

    property :styles
    property :actions
    property :data
    property :templates

    def template name, *args, &block
      property_sender templates, name, *args, &block
    end

    def datum name, *args, &block
      property_sender data, name, *args, &block
    end

    def style name, *args, &block
      property_sender styles, name, *args, &block
    end

    def action name, *args, &block
      property_sender actions, name, *args, &block
    end
  end
end
