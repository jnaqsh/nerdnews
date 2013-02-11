class AddNoteLinkToActivityLogs < ActiveRecord::Migration
  def change
    add_column :activity_logs, :note_link, :string
  end
end
