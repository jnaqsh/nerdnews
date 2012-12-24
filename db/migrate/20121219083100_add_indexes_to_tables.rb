class AddIndexesToTables < ActiveRecord::Migration
  def change
    add_index :stories, :user_id
    add_index :users, :email
    add_index :taggings, [:tag_id, :story_id]
    add_index :roles_users, [:role_id, :user_id]
    add_index :rating_logs, [:user_id]
    add_index :identities, [:provider, :uid]
    add_index :messages, [:sender_id, :receiver_id]
    add_index :votes, [:user_id, :rating_id]
    add_index :votes, [:voteable_id, :voteable_type]
    add_index :comments, [:story_id, :user_id]
    add_index :pages, :permalink
  end
end
