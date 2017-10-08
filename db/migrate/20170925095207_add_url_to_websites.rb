class AddUrlToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :url, :string
  end
end
