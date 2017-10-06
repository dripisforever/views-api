class ChangeColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :websites, :header, :title
  end
end
