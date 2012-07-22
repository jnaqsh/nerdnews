class Tagging < ActiveRecord::Base
  attr_accessible :story_id, :tag_id

  belongs_to :tag
  belongs_to :story
end
