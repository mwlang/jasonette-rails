module Jasonette
  class Body < Jasonette::Base
    property :header
    property :sections, :is_many
  end
end