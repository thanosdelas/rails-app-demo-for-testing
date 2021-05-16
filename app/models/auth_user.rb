class AuthUser < ApplicationRecord
  validates :email, uniqueness: true
end
