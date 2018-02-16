class AddBodiesToSites < ActiveRecord::Migration[5.1]
  def change
    add_column :sites, :body, :string
  end
end
