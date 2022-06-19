class TasksController < ApplicationController
  # @task = Task.find(params[:id]) の部分が複数あるので、フィルタを使ってDRYにする
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    #@tasks = Task.all

    # ログインしているユーザーに紐づくTaskだけ表示する
    # @tasks = current_user.tasks.order(created_at: :desc) # 作成日時の新しい順に検索する
    # @tasks = Task.where(user_id: current_user.id)と同じ結果

    # Rails consoleで User.where(:admin: true).to_sql 生成予定のSQL見れる

    # scopeを使って次のように書ける
    @tasks = current_user.tasks.recent
  end

  def show
    # @task = Task.find(params[:id])
    # このままだとユーザーが適当に「/tasks/32」と打ち込んだら見れてしまう
    # @task = current_user.tasks.find(params[:id]) # current_user付与で、他のユーザーのデータを見ようとしてもはねつけられる

    # DRYをフィルタで実施したbefore_actionのため省略できる
  end

  def new
    @task = Task.new
  end

  def create
    # @インスタンス変数なのは、検証エラー時にviewに検証を行った現物のTaskオブジェクトを渡す必要があるため
    # 1.フォーム送信したデータが入ってるため、前回操作した値をフォームに引き継げる ユーザーが再入力しなくて済む
    # 2.Taskオブジェクトの抱える検証エラーの内容をユーザーに対して表示することができる
    # @task = Task.new(task_params)

    # ユーザーに紐づくデータを登録するため、ログインしているユーザーのuser_idも代入する @task = task.new(task_params.merege(user_id: current_user.id))
    # 定義した関連(Assosiation)を利用して記述もできる オブジェクト指向的でこちらが読みやすく使われる
    @task = current_user.tasks.new(task_params)
    # tasks.newではなく、tasks.buildを使う方法もある
    # 前者はcurrent_userオブジェクトが内部的に抱えるtaskリストを変更し、後者は変更しない。


    # 検証を追加したのでsave!ではなく、saveで戻り値によって制御を変える
    if @task.save
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を登録しました。"
   else
    # 検証結果がfalseなら、登録フォームを表示して再入力を促す
    render :new
   end

    # redirect_toのオプションに直接渡せるFlashキーは、:noticeと:alertのみ
    # warningのキーを渡す場合 redirect_to task_url, flash: {warning: "何かの警告メッセージ"}
    # メソッドの形で渡す場合　　flash.notice = "タスク「#{task.name}」を登録しました。"

    # 同じリクエスト内（直接にレンダーするビューに対して）伝える場合
    # flash.now[:alert] = "提出期限を過ぎています"
    # flash.now.alert = "提出期限を過ぎています"

    # 2つ以上先のリクエストにデータを伝える flash.keep
  end

  def edit
    # @task = Task.find(params[:id])
    # @task = current_user.tasks.find(params[:id])
    # DRYをフィルタで実施したbefore_actionのため省略できる
  end

  def update
    # task = Task.find(params[:id])
    # @task = current_user.tasks.find(params[:id])
    # DRYをフィルタで実施したbefore_actionのため省略できる
    @task.update!(task_params) # 代入先がローカル変数だったので、edit,showに合わせてインスタンス変数に変更
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました" # 同じくインスタンス変数に変更
  end

  def destroy
    # task = Task.find(params[:id])
    # @task = current_user.tasks.find(params[:id])
    # DRYをフィルタで実施したbefore_actionのため省略できる
    @task.destroy # 代入先がローカル変数だったので、edit,showに合わせてインスタンス変数に変更
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。" # 同じくインスタンス変数に変更
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
