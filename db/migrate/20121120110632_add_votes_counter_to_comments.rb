class AddVotesCounterToComments < ActiveRecord::Migration
  def change
    add_column :comments, :positive_votes_count, :integer, default: 0
    add_column :comments, :negative_votes_count, :integer, default: 0
  end
end
