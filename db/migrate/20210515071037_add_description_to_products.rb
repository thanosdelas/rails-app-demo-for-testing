class AddDescriptionToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :description, :string, after: 'name'
  end
end
