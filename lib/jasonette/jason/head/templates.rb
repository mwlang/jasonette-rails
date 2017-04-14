module Jasonette
  class Jason::Head::Templates < Jasonette::Body
    super_property

    def attributes!
      attr = super
      if target_name?
        @attributes = {}
        @attributes[get_target_name] = attr
      end
      @attributes
    end
  end
end
