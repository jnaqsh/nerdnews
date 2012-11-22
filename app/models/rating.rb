class Rating < ActiveRecord::Base
  attr_accessible :name, :weight, :rating_target

  has_many :votes

  validates_numericality_of :weight, greater_than: -6, less_than: 6

  scope :positive, lambda { |target| where('weight > 0 and rating_target = ?', target).order('weight DESC') }
  scope :negative, lambda { |target| where('weight < 0 and rating_target = ?', target).order('weight DESC') }
end
