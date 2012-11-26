class RemoveStoryIdFromVotes < ActiveRecord::Migration
  def up
    remove_column :votes, :story_id
  end

  def down
    add_column :votes, :story_id, :integer
  end
end
