# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  story_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tagging < ActiveRecord::Base
  default_scope { order('position ASC') }

  belongs_to :tag
  belongs_to :story
end
