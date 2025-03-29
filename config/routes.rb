Rails.application.routes.draw do
  devise_for :users, defaults: { format: :json }, skip: [:sessions]
  devise_scope :user do
    post 'users/sign_in', to: 'users/sessions#create', as: :user_login
    delete 'users/sign_out', to: 'users/sessions#destroy', as: :user_logout
  end
end

