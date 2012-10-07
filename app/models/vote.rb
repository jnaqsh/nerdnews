class Vote < ActiveRecord::Base
  attr_accessible :rating_id, :story_id, :user_id

  belongs_to :user
  belongs_to :story
  belongs_to :rating
end
