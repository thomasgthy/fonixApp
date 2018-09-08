Rails.application.routes.draw do
  get 'mobile_numbers/new', to: "mobile_numbers#new", as:"new_mobile_number"
  post 'mobile_numbers/create', to: "mobile_numbers#create", as:"mobile_numbers"
  get 'confirmations/new', to: "confirmations#new", as:"new_confirmation"
  post 'confirmations/create', to: "confirmations#create", as:"confirmations"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "mobile_numbers#new"
end
