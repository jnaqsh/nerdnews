# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  rating_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  voteable_id   :integer
#  voteable_type :string(255)
#

class Vote < ActiveRecord::Base
  belongs_to :voteable, polymorphic: true
  belongs_to :user
  belongs_to :rating

  # validates_presence_of :story, :rating, :user
  validates_uniqueness_of :voteable_id, scope: [:user_id, :voteable_type]

  # Not used anywhere, but who cares? It may come handy later
  # def self.user_voted?(user, story)
  #   !Vote.find_by_user_id_and_story_id(user, story).nil?
  # end
end
