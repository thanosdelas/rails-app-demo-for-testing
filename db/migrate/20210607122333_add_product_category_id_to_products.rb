class AddProductCategoryIdToProducts < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :product_category, null: true, foreign_key: true, after: 'description'
  end
end
