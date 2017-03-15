module Jasonette
  class Jason::Body < Jasonette::Base
    property :header
    property :sections

    def attributes!
      a = super
      a["sections"] = [a["sections"]] if a.has_key?("sections")
      return a
    end
  end
end
