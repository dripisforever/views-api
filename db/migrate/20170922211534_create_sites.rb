class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.string :url
      t.boolean :scrapped
      t.boolean :valid_site
      t.string :title
      t.boolean :business
      t.references :batch, foreign_key: true

      t.timestamps
    end
  end
end
