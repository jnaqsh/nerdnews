class ChangeNoteFromStringToText < ActiveRecord::Migration
  def up
    change_column :activity_logs, :note, :text
  end

  def down
    change_column :activity_logs, :note, :string
  end
end
