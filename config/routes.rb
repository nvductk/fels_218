Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vn/ do
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    root "static_pages#home"
    resources :users
  end
end
