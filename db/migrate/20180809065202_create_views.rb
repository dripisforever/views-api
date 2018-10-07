class CreateViews < ActiveRecord::Migration[5.1]
  def change
    create_table :views do |t|
      t.references :user, foreign_key: true
      t.references :website, foreign_key: true

      t.timestamps
    end
    add_index :views, [:user_id, :website_id], unique: true
  end
end
