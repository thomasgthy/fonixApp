Rails.application.routes.draw do
  get 'mobile_numbers/new', to: "mobile_numbers#new", as:"new_mobile_number"
  get 'mobile_numbers/:id', to: "mobile_numbers#show", as:"mobile_number"
  post 'mobile_numbers/create', to: "mobile_numbers#create", as:"mobile_numbers"
  post 'mobile_numbers/confirm_code/:id', to: "mobile_numbers#confirm_code", as:"confirm_code"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "mobile_numbers#new"
end
