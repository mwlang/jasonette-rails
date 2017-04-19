module Jasonette
  class Options < Jasonette::Base
    property :data, :is_many
    property :action
    property :form, :is_many
    property :items
  end
end
