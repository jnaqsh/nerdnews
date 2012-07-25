class Page < ActiveRecord::Base
  attr_accessible :content, :name, :permalink
  validates :content, presence: true
  validates :permalink, uniqueness: true, length: {maximum: 50, minimum: 3}, presence: true
  validates :name, length: {maximum: 20, minimum: 3}, presence: true
end
