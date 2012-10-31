class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
  belongs_to :rating

  validates_presence_of :story, :rating

  # Not used anywhere, but who cares? It may come handy later
  def self.user_voted?(user, story)
    !Vote.find_by_user_id_and_story_id(user, story).nil?
  end
end
