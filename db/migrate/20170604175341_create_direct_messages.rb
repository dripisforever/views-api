class CreateDirectMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :direct_messages do |t|
      t.string :title

      t.timestamps
    end
  end
end
