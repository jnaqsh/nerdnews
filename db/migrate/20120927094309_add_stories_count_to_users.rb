class AddStoriesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stories_count, :integer, default: 0
  end
end
