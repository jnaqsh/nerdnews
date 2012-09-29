class CreateRatingLogs < ActiveRecord::Migration
  def change
    create_table :rating_logs do |t|
      t.integer :user_id
      t.string :event

      t.timestamps
    end
  end
end
