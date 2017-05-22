require 'rails/railtie'
require 'jasonette/handler'
require 'jasonette/action_view_extensions'
require 'jasonette/helpers'

module Jasonette
  class Railtie < ::Rails::Railtie
    initializer :jasonette do
      ActiveSupport.on_load :action_view do
        ActionView::Template.register_template_handler :jasonette, Jasonette::Handler
        include Jasonette::Helpers
      end

      # if Rails::VERSION::MAJOR >= 5
      #   module ::ActionController
      #     module ApiRendering
      #       include ActionView::Rendering
      #     end
      #   end
      #
      #   ActiveSupport.on_load :action_controller do
      #     if self == ActionController::API
      #       include ActionController::Helpers
      #       include ActionController::ImplicitRender
      #     end
      #   end
      # end
    end
  end
end
