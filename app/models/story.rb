class Story < ActiveRecord::Base
  attr_accessible :content, :excerpt, :publish_date, :title
  validates_length_of :title, maximum: 100, minimum: 10
  validates_length_of :content, minimum: 20, maximum: 1000
  validates  :title, :content, :excerpt, presence: true
end
