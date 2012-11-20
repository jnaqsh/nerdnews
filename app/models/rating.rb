class Rating < ActiveRecord::Base
  attr_accessible :name, :weight

  has_many :votes

  validates_numericality_of :weight, greater_than: -6, less_than: 6

  scope :positive, where('weight > 0').order('weight DESC')
  scope :negative, where('weight < 0').order('weight DESC')
end
