module Jasonette
  class Layout < Jasonette::Base
    property :components

    def attributes!
      @attributes.merge components.attributes!
    end
  end
end
