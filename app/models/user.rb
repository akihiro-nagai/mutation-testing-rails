class User < ApplicationRecord
  has_many :blogs, dependent: :destroy
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
