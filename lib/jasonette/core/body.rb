module Jasonette
  class Body < Jasonette::Base
    property :header
    property :footer
    property :sections, :is_many
    property :layers
    property :style

    def attributes!
      super
      @attributes.merge! layers.attributes!
    end
  end
end