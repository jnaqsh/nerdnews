class AddDeletedAtToComments < ActiveRecord::Migration
  def change
    add_column :comments, :deleted_at, :datetime
  end
end
