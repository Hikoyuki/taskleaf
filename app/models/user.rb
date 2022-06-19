class User < ApplicationRecord
  # 1行追加で has_secure_passwordが使える
  # これによりデータベースのカラムにない2つの属性が追加される
  # password属性 入力されたパスワードを一時的に格納するための属性 メモリ上に一時的
  # password_confirmation パスワード登録時に確認用のパスワードを入力用 同様に一時的にUserクラスで格納
  # 2つが一致するか検証が走る 一致する場合にpassword_digestが生成される
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :tasks # user.tasks といったメソッド関連(Assosiation)で紐づくTaskオブジェクト一覧を取得可能に
end
