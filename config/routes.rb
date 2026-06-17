Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resource :profile, only: [:show, :edit, :update]
  resources :expenses do
    collection do
      patch :update_currency
    end
  end

end