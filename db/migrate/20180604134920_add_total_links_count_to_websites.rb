class AddTotalLinksCountToWebsites < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :total_links_count, :integer
  end
end
