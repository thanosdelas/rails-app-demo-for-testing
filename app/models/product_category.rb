class ProductCategory < ApplicationRecord
	belongs_to :parent_category, class_name: 'ProductCategory', foreign_key: 'parent_id', optional: true
end
