module Jasonette
  class Body::Layers < Jasonette::Items

    private
    def append builder
      @attributes["layers"] ||= []
      @attributes["layers"] << builder.attributes!
      builder
    end
  end
end
