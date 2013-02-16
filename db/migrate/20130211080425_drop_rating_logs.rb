class DropRatingLogs < ActiveRecord::Migration
  def up
    drop_table :rating_logs
  end

  def down
    create_table :rating_logs do |t|
      t.integer :user_id
      t.string :event

      t.timestamps
    end
  end
end
