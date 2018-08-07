class AddLikesCountToWebsites < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :likes_count, :integer, default: 0
  end
end
