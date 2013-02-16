class AddRemoverIdToStories < ActiveRecord::Migration
  def change
    add_column :stories, :remover_id, :integer
  end
end
