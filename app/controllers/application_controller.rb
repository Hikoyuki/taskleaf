class ApplicationController < ActionController::Base
  # ログイン中のユーザーは頻繁に呼び出すため、コントローたやビューから簡単に呼び出せるようにするのが定石
  # helper_methodを指定することで全てのビューから使える Railsで用意されたモジュール
  helper_method :current_user
  # コントローラの「フィルタ」機能　アクション実行前に任意の処理を挟むことができる onlyオプションで適用するアクションの指定もできる
  before_action :login_required

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_url unless current_user
  end
end
