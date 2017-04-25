module Jasonette
  class Options < Jasonette::Base
    property :data, :is_many, :is_single
    property :action
    property :form, :is_many
    property :items
  end
end
