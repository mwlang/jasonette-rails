module Jasonette
  class Options < Jasonette::Base
    property :data

    def attributes!
      a = super
      a["data"] = [a["data"]] if a.has_key?("data")
      return a
    end
  end
end
