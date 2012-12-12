class AddTotalPointToStoriesAndComments < ActiveRecord::Migration
  def change
    add_column :stories, :total_point, :integer, default: 0
    add_column :comments, :total_point, :integer, default: 0

    Story.find_each do |s|
      sum = 0
      s.votes.each do |vote|
        sum += vote.rating.weight
      end
      s.update_attribute :total_point, sum
    end

    Comment.find_each do |c|
      sum = 0
      c.votes.each do |vote|
        sum += vote.rating.weight
      end
      c.update_attribute :total_point, sum
    end
  end
end
