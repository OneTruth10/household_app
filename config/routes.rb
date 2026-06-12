Rails.application.routes.draw do
  devise_for :users
  
  # 出費に関する標準的なURL（index, new, createなど）をまとめて有効化
  resources :expenses
  # アプリのトップページを、ログイン後は出費一覧画面（expenses#index）に設定
  root 'expenses#index'
end