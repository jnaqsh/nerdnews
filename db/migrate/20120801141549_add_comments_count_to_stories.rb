class AddCommentsCountToStories < ActiveRecord::Migration
  def change
    add_column :stories, :comments_count, :integer, :default => 0
  end
end
