class AddDeletedAtToStories < ActiveRecord::Migration
  def change
    add_column :stories, :deleted_at, :datetime
  end
end
