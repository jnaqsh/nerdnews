class AddPositiveVotesCountAndNegativeVotesCountToStory < ActiveRecord::Migration
  def change
    add_column :stories, :positive_votes_count, :integer, default: 0
    add_column :stories, :negative_votes_count, :integer, default: 0
  end
end
