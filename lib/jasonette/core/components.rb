module Jasonette
  class Components < Jasonette::Items

    private

    def append builder
      @attributes["components"] ||= []
      @attributes["components"] << builder.attributes!
      self
    end

  end
end
