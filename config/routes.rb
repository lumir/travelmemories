Travelmemories::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions', registrations: "users/registrations" }

  root to: "pages#index"

  match "/get_checkins", to: "user_steps#get_checkins"
  match "/get_photos", to: "user_steps#get_photos"

  match "/users/:id/timeline", to: "public_pages#timeline", as: :timeline
  match "/users/:user_id/travels/:id", to: "public_pages#show_travel", as: :show_travel

  resources :travels, on: :collection do
    resources :checkins
  end

  resources :users, only: [:edit, :update]

  resources :friendships do
    collection do
      post :invite
    end
  end

  resources :user_steps, path: "steps"

end
