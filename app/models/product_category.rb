class ProductCategory < ApplicationRecord
	# If you use dependent: :destroy child deletes parent category
	belongs_to :parent_category, class_name: 'ProductCategory', foreign_key: 'parent_id', optional: true
	# You can delete all children with parent using has_many
	has_many :parent_categories, class_name: 'ProductCategory', foreign_key: 'parent_id', dependent: :destroy
	validates :name, presence: true, length: { minimum: 5 }

	NULL_ATTRS = %w( parent_id )

	before_save :blank_parent_category

	protected

		def blank_parent_category
			NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? || self[attr]==0 }
		end
end
