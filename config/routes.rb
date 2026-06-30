Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :users, only: [:index, :show] do 
    collection do
      get :followings
    end
  end
  resource :profile, only: [:show, :edit, :update]
  resources :expenses do
    collection do
      patch :update_currency
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end
end