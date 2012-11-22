class AddRefrencesToVotes < ActiveRecord::Migration
  def change
    change_table :votes do |v|
      v.references :voteable, polymorphic: true
    end

    Vote.find_each do |v|
      v.update_attribute :voteable_id, v.story_id.to_i
      v.update_attribute :voteable_type, 'Story'
    end
  end
end
