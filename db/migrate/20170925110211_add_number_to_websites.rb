class AddNumberToWebsites < ActiveRecord::Migration[5.0]
  def change
    add_column :websites, :number, :integer
  end
end
