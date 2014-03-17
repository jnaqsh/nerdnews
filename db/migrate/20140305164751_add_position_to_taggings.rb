class AddPositionToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :position, :integer
  end
end
