module Jasonette
  class Body < Jasonette::Base
    property :header
    property :sections, true
  end
end