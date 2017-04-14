module Jasonette
  class Options < Jasonette::Base
    property :data
    property :action
    property :form
    property :items

    def attributes!
      a = super
      a["data"] = [a["data"]] if a.has_key?("data")
      a["form"] = [a["form"]] if a.has_key?("form")
      @attributes.merge items.attributes!
      return a
    end
  end
end
