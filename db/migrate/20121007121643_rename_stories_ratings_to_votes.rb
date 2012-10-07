class RenameStoriesRatingsToVotes < ActiveRecord::Migration
  def change
    rename_table :stories_ratings, :votes
  end
end
