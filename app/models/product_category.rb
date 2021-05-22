class ProductCategory < ApplicationRecord
	# If you use dependent: :destroy child deletes parent category
	belongs_to :parent_category, class_name: 'ProductCategory', foreign_key: 'parent_id', optional: true
	# You can delete all children with parent using has_many
	has_many :parent_categories, class_name: 'ProductCategory', foreign_key: 'parent_id', dependent: :destroy
end