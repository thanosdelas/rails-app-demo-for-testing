class Product < ApplicationRecord
  validates :name, presence: true, length: { minimum: 5 }, uniqueness: true
  validates :description, presence: true, length: { minimum: 10 }
  belongs_to :product_category, class_name: 'ProductCategory', foreign_key: 'product_category_id', required: true
end
