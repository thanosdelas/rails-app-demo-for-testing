class AddParentIdToProductCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :product_categories, :parent_id, :integer, after: 'name'
  end
end
