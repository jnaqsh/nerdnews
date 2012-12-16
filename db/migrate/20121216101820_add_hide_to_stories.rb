class AddHideToStories < ActiveRecord::Migration
  def change
    add_column :stories, :hide, :boolean, default: false
  end
end
