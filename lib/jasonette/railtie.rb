require 'rails/railtie'
require 'jbuilder/jbuilder_template'

class Jasonette
  class Railtie < ::Rails::Railtie
    initializer :jason do
      ActiveSupport.on_load :action_view do
        ActionView::Template.register_template_handler :jason, JasonHandler
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
