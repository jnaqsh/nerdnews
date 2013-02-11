class ChangeNoteLinkFromActivityLogs < ActiveRecord::Migration
  def up
    change_column :activity_logs, :note_link, :text
  end

  def down
    change_column :activity_logs, :note_link, :string
  end
end
