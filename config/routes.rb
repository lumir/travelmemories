Travelmemories::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", sessions: 'users/sessions', registrations: "users/registrations" }

  root to: "pages#index"

  match "/get_checkins", to: "user_steps#get_checkins"

  resources :users, only: [:edit] do
    resources :travels do
      resources :checkins
    end
  end

  resources :friendships do
    collection do
      post :invite
    end
  end

  resources :user_steps, path: "steps"

end
