class User < ApplicationRecord
  has_secure_password 
  has_secure_token :api_token

  enum :role, { user: 0, admin: 1 }, default: :user
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
