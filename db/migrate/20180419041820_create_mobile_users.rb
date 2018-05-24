class CreateMobileUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :mobile_users do |t|
      t.integer :phone_number
      t.string :username
      t.string :name

      t.timestamps
    end
    add_index :mobile_users, :phone_number, unique: true
    add_index :mobile_users, :username, unique: true
  end
end
