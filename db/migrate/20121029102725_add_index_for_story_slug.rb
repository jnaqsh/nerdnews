class AddIndexForStorySlug < ActiveRecord::Migration
  def up
    add_index :stories, :slug
  end

  def down
    remove_index :stories, :slug
  end
end
