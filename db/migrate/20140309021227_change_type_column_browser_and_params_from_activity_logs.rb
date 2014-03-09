class ChangeTypeColumnBrowserAndParamsFromActivityLogs < ActiveRecord::Migration
  def change
    change_column :activity_logs, :params, :text
    change_column :activity_logs, :browser, :string, limit: 1000
  end
end
