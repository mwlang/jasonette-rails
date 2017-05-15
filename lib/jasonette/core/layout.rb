module Jasonette
  class Layout < Jasonette::Item
    super_property
    property :components

    def attributes!
      super
      @attributes.merge components.attributes!
    end
  end
end
