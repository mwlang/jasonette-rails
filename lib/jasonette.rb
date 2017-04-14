require 'rails/railtie'
require 'jbuilder/jbuilder_template'

module Jasonette
  if Object.const_defined? "Rails::Engine"
    require_relative 'jasonette/engine'
  end
end

# Core components for library
require_relative 'jasonette/core/properties'
require_relative 'jasonette/core/base'
require_relative 'jasonette/core/style'
require_relative 'jasonette/core/sections'
require_relative 'jasonette/core/items'
require_relative 'jasonette/core/layout'
require_relative 'jasonette/core/components'
require_relative 'jasonette/core/options'
require_relative 'jasonette/core/action'
require_relative 'jasonette/core/body'
require_relative 'jasonette/core/data'

# Structural components
require_relative 'jasonette/jason'
require_relative 'jasonette/jason/head'
require_relative 'jasonette/jason/head/actions'
require_relative 'jasonette/jason/head/templates'
require_relative 'jasonette/jason/body'
require_relative 'jasonette/jason/body/header'
require_relative 'jasonette/jason/body/header/search'

# Inject Jasonette into Jbuilder
require_relative 'jasonette/jbuilder_extensions'
