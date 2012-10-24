class AddSourceToStories < ActiveRecord::Migration
  def change
    add_column :stories, :source, :string
  end
end
