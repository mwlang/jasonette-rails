module Jasonette
  class Map < Jasonette::Item
    super_property
    property :pins, :is_many
  end
end
