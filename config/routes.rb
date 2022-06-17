Rails.application.routes.draw do
  # Railsでのログインする＝「セッションというリソースを作る」WEBアプリのセッションとは違う
  # r g controller Sessions new  URLを/loginにしたいので設定を変更
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # r g controller Admin::Users new edit .. コントローラのモジュールの名前空間
  namespace :admin do # namespasce :adminの中に定義してるため、URLに/admin、ヘルパーメソッドにadmin_ がつくようになる
    resources :users
  end

  root to: 'tasks#index'
  resources :tasks
end
