Rails.application.routes.draw do
  devise_for :event_organizers, controllers: {
    registrations: 'event_organizers/registrations',
    sessions: 'event_organizers/sessions'
  }, defaults: { format: :json }

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }, defaults: { format: :json }

  resources :events, only: [:index, :show, :create, :update, :destroy] do
    resources :tickets, only: [:index, :show, :create, :update, :destroy]
  end
  get 'get_all_tickets', to: 'tickets#get_all_tickets'
  resources :bookings, only: [:index, :show, :create]
end
