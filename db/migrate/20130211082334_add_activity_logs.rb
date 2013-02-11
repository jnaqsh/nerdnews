class AddActivityLogs < ActiveRecord::Migration
  def up
    create_table "activity_logs", :force => true do |t|
      t.string "user_id"
      t.string "browser"
      t.string "ip_address"
      t.string "controller"
      t.string "action"
      t.string "params"
      t.string "note"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

  def down
    drop_table :activity_logs
  end
end
