class AddFavoritesTagsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorite_tags, :string
  end
end
