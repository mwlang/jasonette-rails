Rails.application.routes.draw do
  resources :posts do
    collection do
      get "partial"
      get "helper"
      get "action_partial"
      get "action_in_partial"
      get "with_layout"
      get "without_layout"
      get "with_template_vars"
      get "as_json"
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
