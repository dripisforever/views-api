class AddDetailsToQueries < ActiveRecord::Migration[5.1]
  def change
    add_column :queries, :printed_count, :integer
  end
end
