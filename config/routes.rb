Rails.application.routes.draw do
  devise_for :users
  

  resources :expenses do
    collection do
      patch :update_currency
    end
  end

  # アプリのトップページを、ログイン後は出費一覧画面（expenses#index）に設定
  root 'expenses#index'
end