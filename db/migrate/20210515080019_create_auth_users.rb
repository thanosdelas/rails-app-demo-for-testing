class CreateAuthUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :auth_users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :phone
      t.string :address

      t.timestamps
    end
  end
end
