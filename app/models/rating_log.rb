class RatingLog < ActiveRecord::Base
  attr_accessible :event, :user_id

  belongs_to :user

  validates_presence_of :event
end
