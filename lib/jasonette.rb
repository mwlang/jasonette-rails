# Core components for library
require_relative 'jasonette/core/properties'
require_relative 'jasonette/core/base'
require_relative 'jasonette/core/style'
require_relative 'jasonette/core/item'
require_relative 'jasonette/core/items'
require_relative 'jasonette/core/layout'
require_relative 'jasonette/core/map'
require_relative 'jasonette/core/pins'
require_relative 'jasonette/core/components'
require_relative 'jasonette/core/options'
require_relative 'jasonette/core/action'
require_relative 'jasonette/core/data'
require_relative 'jasonette/core/body'
require_relative 'jasonette/core/body/header'
require_relative 'jasonette/core/body/header/search'
require_relative 'jasonette/core/body/footer'
require_relative 'jasonette/core/body/footer/input'
require_relative 'jasonette/core/body/footer/tabs'
require_relative 'jasonette/core/body/sections'
require_relative 'jasonette/core/body/layers'

# Structural components
require_relative 'jasonette/jason'
require_relative 'jasonette/jason/head'
require_relative 'jasonette/jason/head/actions'
require_relative 'jasonette/jason/head/templates'
require_relative 'jasonette/jason/body'

module Jasonette
  def self.setup
    yield self
  end

  # :dump_options, :load_options
  def self.multi_json
    yield ::MultiJson
  end
end
