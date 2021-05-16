class AuthUser < ApplicationRecord
	has_one :auth_user_detail
	accepts_nested_attributes_for :auth_user_detail
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true, length: { minimum: 10 }
end
