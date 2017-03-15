module Jasonette
  class Sections < Jasonette::Base
    property :items

    def attributes!
      @attributes.merge items.attributes!
    end
  end
end
