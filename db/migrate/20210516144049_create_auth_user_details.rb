class CreateAuthUserDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :auth_user_details do |t|
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :address
      t.references :auth_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
