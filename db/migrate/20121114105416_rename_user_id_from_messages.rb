class RenameUserIdFromMessages < ActiveRecord::Migration
  def up
    rename_column :messages, :user_id, :sender_id
  end

  def down
    rename_column :messages, :sender_id, :user_id
  end
end
