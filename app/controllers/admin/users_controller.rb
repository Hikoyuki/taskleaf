class Admin::UsersController < ApplicationController
  # 管理者権限を持つユーザーだけがユーザー管理機能を利用できるようにする
  # 管理者以外の利用を禁止するフィルタとしてrequire_adminメソッドを追加
  before_action :require_admin

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_url(@user), notice: "ユーザー「#{@user.name}」を登録しました。"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to admin_user_url(@user), notice: "ユーザー「#{@user.name}」を更新しました。"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url, notice: "ユーザー「#{@user.name}」を更新しました。"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :admin, :password, :password_confirmation)
  end

  def require_admin
    redirect_to root_url unless current_user.admin?
    # /admin/usersのパスに何かしらアクションがあることがわかる
    # 管理機能の存在自体を隠すのであれば、アクションが存在しない時と同じようにHTTPSステータスコード404を返すコードを書くのも良い
    # 最初のユーザーはRailsコンソールで作る必要がある もしくはseedを利用
  end
end
