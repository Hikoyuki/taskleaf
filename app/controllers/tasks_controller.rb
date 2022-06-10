class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    # @インスタンス変数なのは、検証エラー時にviewに検証を行った現物のTaskオブジェクトを渡す必要があるため
    # 1.フォーム送信したデータが入ってるため、前回操作した値をフォームに引き継げる ユーザーが再入力しなくて済む
    # 2.Taskオブジェクトの抱える検証エラーの内容をユーザーに対して表示することができる
    @task = Task.new(task_params)

    # 検証を追加したのでsave!ではなく、saveで戻り値によって制御を変える
    if @task.save
      redirect_to tasks_url, notice: "タスク「#{task.name}」を登録しました。"
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
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.update!(task_params)
    redirect_to tasks_url, notice: "タスク「#{task.name}」を更新しました"
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to tasks_url, notice: "タスク「#{task.name}」を削除しました。"
  end

  private
  def task_params
    params.require(:task).permit(:name, :description)
  end
end
