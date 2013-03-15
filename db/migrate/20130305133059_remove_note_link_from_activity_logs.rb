class RemoveNoteLinkFromActivityLogs < ActiveRecord::Migration
  def up
    remove_column :activity_logs, :note_link
  end

  def down
    add_column :activity_logs, :note_link, :text
  end
end
