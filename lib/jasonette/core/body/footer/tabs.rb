module Jasonette
  class Body::Footer::Tabs < Jasonette::Base
    property :style
    property :items

    def attributes!
      super
      @attributes.merge! items.attributes!
    end
  end
end