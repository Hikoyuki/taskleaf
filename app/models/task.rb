class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  # validates :name, presence: true, length: { maximum: 30 }
  # 1行でも書けるが、検証内容が複雑になるため一概にどちらがいいか言えない

  # 検証コードをメソッドを使って指定する
  validate :validate_name_not_including_comma

  # 検証前の正規化 コールバック処理で「名前なし」を自動でつける例
  # before_validation :set_nameless_name

  private

  # 検証メソッドの基本的は仕事「検証エラーを発見したら、errorsにエラー内容を格納する」
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  # def set_nameless_name
  #   self.name = '名前なし' if name.blank?
  # end
end
