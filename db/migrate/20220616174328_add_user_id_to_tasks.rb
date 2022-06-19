class AddUserIdToTasks < ActiveRecord::Migration[5.2]
  def up
    # ''内のSQLで、今まで作られたタスクが全て削除　既存のタスクに紐づくものが決められずNOT NULL制約に引っかかるのを防ぐ
    # 本番環境で運用が始まってるものにNOT NULL制約にカラムを追加するには、制約なしでカラムを追加、追加したカラムに値を入れるデータメンテナンス後、カラムにNOT NULL制約をつける
    execute 'DELETE FROM tasks;'
    add_reference :tasks, :user, null: false, index: true
  end

  def down
    remove_reference :tasks, :user, index: true
  end
end
