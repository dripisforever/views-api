class CreateWebsites < ActiveRecord::Migration[5.0]
  def change
    create_table :websites do |t|
      t.string :name
      t.string :header
      t.string :body

      t.timestamps
    end
  end
end
