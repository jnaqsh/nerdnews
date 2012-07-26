class RemoveExcerptFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :excerpt
  end
end
