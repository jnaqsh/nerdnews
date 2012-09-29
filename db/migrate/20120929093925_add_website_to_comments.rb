class AddWebsiteToComments < ActiveRecord::Migration
  def change
    add_column :comments, :website, :string
    add_column :users, :website, :string
  end
end
