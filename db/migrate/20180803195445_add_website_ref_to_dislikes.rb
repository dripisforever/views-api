class AddWebsiteRefToDislikes < ActiveRecord::Migration[5.1]
  def change
    add_reference :dislikes, :website, foreign_key: true
  end
end
