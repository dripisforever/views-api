class AddDetailsToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :inside_links, :string
    add_column :sites, :outside_links, :string
  end
end
