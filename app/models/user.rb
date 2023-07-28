class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  has_many :likes, dependent: :destroy
  has_many :tweets, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/i

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: VALID_EMAIL_REGEX, allow_blank: true }
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true

  enum role: { member: 0, admin: 1 }
end
