Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "/redirect", to: "calendars#redirect", as: 'redirect'
  get "/callback", to: "calendars#callback", as: 'callback'
  get '/calendars', to: 'calendars#calendars', as: 'calendars'
  get '/events/:calendar_id', to: 'calendars#events', as: 'events', calendar_id: /[^\/]+/
  post '/events/:calendar_id', to: 'calendars#new_event', as: 'new_event', calendar_id: /[^\/]+/
end
