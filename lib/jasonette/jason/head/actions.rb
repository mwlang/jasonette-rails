module Jasonette
  class Jason::Head::Actions < Jasonette::Action
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
