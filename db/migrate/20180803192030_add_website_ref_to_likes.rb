class AddWebsiteRefToLikes < ActiveRecord::Migration[5.1]
  def change
    add_reference :likes, :website, foreign_key: true
  end
end
