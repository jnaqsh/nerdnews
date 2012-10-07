class RemoveStoriesPercentageFromTags < ActiveRecord::Migration
  def up
    remove_column :tags, :stories_percentage
  end

  def down
    add_column :tags, :stories_percentage, :integer, default: 0
  end
end
