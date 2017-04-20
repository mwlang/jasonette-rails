Rails.application.routes.draw do
  resources :posts do
    collection do
      get "partial"
      get "inline"
      get "mixing"
      get "helper"
      get "action_partial"
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
