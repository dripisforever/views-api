class AddLockedAtToWebsites < ActiveRecord::Migration[5.1]
  def change
    add_column :websites, :locked_at, :datetime
    add_column :websites, :fetched, :boolean, default: false, null: false
    add_column :websites, :links, :text
    add_column :websites, :error_code, :integer
    add_column :websites, :error_message, :text
  end
end
