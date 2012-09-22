class AddCounterToStories < ActiveRecord::Migration
  def change
    add_column :stories, :view_counter, :integer, default: 0
  end
end
