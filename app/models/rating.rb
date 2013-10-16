class Rating < ActiveRecord::Base
  has_many :votes

  validates_numericality_of :weight, greater_than: -6, less_than: 6
  validates_presence_of :name, :weight, :rating_target

  scope :positive, lambda { |target| where('weight > 0 and rating_target = ?', target).order('weight DESC') }
  scope :negative, lambda { |target| where('weight < 0 and rating_target = ?', target).order('weight DESC') }
end
