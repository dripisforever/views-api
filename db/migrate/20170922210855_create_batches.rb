class CreateBatches < ActiveRecord::Migration[5.0]
  def change
    create_table :batches do |t|
      t.string :status
      t.text :keywords
      t.datetime :started_time
      t.datetime :finish_time

      t.timestamps
    end
  end
end
