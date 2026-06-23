Rails.application.routes.draw do
  get 'users/index'
  get 'relationships/create'
  get 'relationships/destroy'
  devise_for :users
  root 'home#index'
  resources :users, only: [:index] do 
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
end