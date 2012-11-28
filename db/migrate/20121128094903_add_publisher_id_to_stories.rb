class AddPublisherIdToStories < ActiveRecord::Migration
  def change
    add_column :stories, :publisher_id, :integer
  end
end
