class RenameReciverIdFromMessages < ActiveRecord::Migration
  def up
    rename_column :messages, :reciver_id, :receiver_id
  end

  def down
    rename_column :messages, :receiver_id, :reciver_id
  end
end
