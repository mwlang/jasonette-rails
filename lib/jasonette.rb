require 'rails/railtie'
require 'jbuilder/jbuilder_template'

# Core components for library
require_relative 'jasonette/core/properties'
require_relative 'jasonette/core/base'
require_relative 'jasonette/core/style'
require_relative 'jasonette/core/sections'
require_relative 'jasonette/core/items'
require_relative 'jasonette/core/layout'
require_relative 'jasonette/core/components'

# Structural components
require_relative 'jasonette/jason'
require_relative 'jasonette/jason/head'
require_relative 'jasonette/jason/body'
require_relative 'jasonette/jason/body/header'
require_relative 'jasonette/jason/body/header/search'

# Inject Jasonette into Jbuilder
require_relative 'jasonette/jbuilder_extensions'

module Jasonette
end
