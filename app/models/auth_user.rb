class AuthUser < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true, length: { minimum: 10 }
end
