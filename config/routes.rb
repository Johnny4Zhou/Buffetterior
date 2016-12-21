Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get '/test' => 'home#test', as: :test
  get '/search' => 'quotes#search', as: :search_quote

  resources :quotes, only: [:show] do
    get "/charts" => "quotes#charts"
    get "/financials" => "quotes#financials"
  end
end
