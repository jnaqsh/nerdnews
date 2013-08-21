class AddEmailVisibilityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_visibility, :boolean, default: true
  end
end
