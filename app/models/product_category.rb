class ProductCategory < ApplicationRecord
	# If you use dependent: :destroy child deletes parent category
	belongs_to :parent_category, class_name: 'ProductCategory', foreign_key: 'parent_id', optional: true
	# You can delete all children with parent using has_many
	has_many :parent_categories, class_name: 'ProductCategory', foreign_key: 'parent_id', dependent: :destroy
	validates :name, presence: true, length: { minimum: 5 }

	NULL_ATTRS = %w( parent_id )

	before_save :blank_parent_category

  def self.children_ids(parent_id)

    query = "
      SELECT id, name, parent_id
      FROM (SELECT * FROM product_categories
      	ORDER BY parent_id, id)
      product_categories,
      (SELECT @pv := ? ) initialisation
      WHERE find_in_set(parent_id, @pv) > 0
      AND @pv := CONCAT(@pv, ',', id)
    "

    # children = ActiveRecord::Base.connection.exec_query(query, 100)
    children = ActiveRecord::Base.connection.exec_query(
    	ActiveRecord::Base.send(:sanitize_sql_array, [query, parent_id])
    )

    collect_ids = []

    collect_ids.push(parent_id)

  	children.each do |category|
  		collect_ids.push(category["id"])
  	end

    return collect_ids
  end

	protected

		def blank_parent_category
			NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? || self[attr]==0 }
		end
end
