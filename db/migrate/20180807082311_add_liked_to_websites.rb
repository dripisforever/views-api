class AddLikedToWebsites < ActiveRecord::Migration[5.1]
  def change
      add_column :websites, :liked, :boolean, default: false, null: false
      add_column :websites, :disliked, :boolean, default: false, null: false
  end
end
