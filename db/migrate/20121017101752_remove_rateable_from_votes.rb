class RemoveRateableFromVotes < ActiveRecord::Migration
  def up
    remove_column :votes, :rateable_id
    remove_column :votes, :rateable_type
  end

  def down
    add_column :votes, :rateable_id, :integer
    add_column :votes, :rateable_type, :integer
  end
end
