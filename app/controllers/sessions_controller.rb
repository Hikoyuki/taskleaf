class SessionsController < ApplicationController
  # 特定のコントローたにおいて、親クラスなどで定義済みのフィルタを通らないようにする
  skip_before_action :login_required

  def new
  end

  def create
    # 送られたパスワードを検索する
    user = User.find_by(email: session_params[:email])

    # パスワードによる認証をauthenticateメソッドで実施 Userクラスにhas_secure_passwordを記述したことで使える
    # 引数で受け取ったパスワードをハッシュ化して、Userオブジェクト内部に保存されているdigestと一致するか調べる　一致:Userオブジェクト 不一致:false
    # メールアドレス見つからずuserがnilになるため、ぼっち演算子にしてエラー回避
    if user&.authenticate(session_params[:password])
      # 認証に成功したらセッションにuser_idを格納する これでUser.find_by(id: session[:user_id])セッションが生きてる限り呼び出せる
      # 1.誰もログインしていない状態　session[:user_id]がnil
      # 2.誰かがログインしている状態　session[:user_id]にログイン中のユーザーIDが入っている
      session[:user_id] = user.id
      redirect_to root_url, notice: 'ログインしました。'
    else
      render :new
    end
  end

  def destroy
    # ログアウト session[:user_id]にnilが入っている状態 session.delete(:user_id)
    # user_idだけでなく、紐づく他の情報をセッションに入れている場合は、セッション内のデータを全て削除する reset_sessionを使う
    reset_session
    redirect_to root_url, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
