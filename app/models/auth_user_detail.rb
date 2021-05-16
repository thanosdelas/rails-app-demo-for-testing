class AuthUserDetail < ApplicationRecord
  belongs_to :auth_user
  validates :firstname, presence: true, length: { minimum: 3 }
  validates :lastname, presence: true, length: { minimum: 3 }  
end
