class AddEmailAndUserIdToComment < ActiveRecord::Migration
  def change
    add_column :comments, :user_id, :integer
    add_column :comments, :email, :string
  end
end
