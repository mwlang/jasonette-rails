# require 'rails/railtie'
# require 'jbuilder/jbuilder_template'
#
# module Jasonette
#   if Object.const_defined? "Rails::Engine"
#     require_relative 'jasonette/engine'
#   end
# end

require_relative 'jasonette'

# require_relative 'jasonette/handler'
#
# class Jasonette
#   class Railtie < ::Rails::Railtie
#     initializer :jason do
#       ActiveSupport.on_load :action_view do
#         ActionView::Template.register_template_handler :jason, Jasonette::Handler
#       end
#
#       # if Rails::VERSION::MAJOR >= 5
#       #   module ::ActionController
#       #     module ApiRendering
#       #       include ActionView::Rendering
#       #     end
#       #   end
#       #
#       #   ActiveSupport.on_load :action_controller do
#       #     if self == ActionController::API
#       #       include ActionController::Helpers
#       #       include ActionController::ImplicitRender
#       #     end
#       #   end
#       # end
#     end
#   end
# end
