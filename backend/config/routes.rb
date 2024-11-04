Rails.application.routes.draw do
  
  scope :api do
    resources :items
    resources :tables
    resources :products
    resources :orders do
      patch :in_progress, on: :member
      patch :finished, on: :member
    end
  end
  mount ActionCable.server => '/cable'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
