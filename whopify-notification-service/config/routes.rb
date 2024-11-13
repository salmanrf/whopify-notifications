Rails.application.routes.draw do
  root to: "home#index"

  # Products
  get "/products", to: "products#index"

  # Webhooks
  post "/webhooks", to: "webhooks/custom_webhooks#receive"

  # Custom CORS handling
  # options "/api/*path", to: "cors#handle"

  # Notification Subscriptions
  get "/notification-subscriptions/actions/shop", to: "notification_subscriptions#shop"
  post "/api/notification-subscriptions", to: "notification_subscriptions_api#create"
  get "/unsubscribe", to: "notification_subscriptions#unsubscribe"
  get "/unsubscribed", to: "notification_subscriptions#unsubscribed"
  post "/unsubscribe", to: "notification_subscriptions_api#unsubscribe"

  mount ShopifyApp::Engine, at: "/"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
