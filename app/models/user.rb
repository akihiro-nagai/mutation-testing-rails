class User < ApplicationRecord
  has_many :blogs, dependent: :destroy
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # mutant 用雑実装
  def is_admin?
    return true if admin? || username == "admin"

    false
  end
end
