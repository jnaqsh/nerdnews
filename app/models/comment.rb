class Comment < ActiveRecord::Base
  belongs_to :story

  attr_accessible :content, :name

  validates :name, :content, presence: true
end
