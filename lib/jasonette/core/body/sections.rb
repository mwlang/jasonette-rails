module Jasonette
  class Body::Sections < Jasonette::Base
    property :items

    def attributes!
      super
      @attributes.merge! items.attributes!
    end
  end
end
