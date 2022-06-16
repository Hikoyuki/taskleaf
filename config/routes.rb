Rails.application.routes.draw do
  # r g controller Admin::Users new edit .. コントローラのモジュールの名前空間
  namespace :admin do # namespasce :adminの中に定義してるため、URLに/admin、ヘルパーメソッドにadmin_ がつくようになる
    resources :users
  end

  root to: 'tasks#index'
  resources :tasks
end
