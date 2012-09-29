class Comment < ActiveRecord::Base
  belongs_to :story, counter_cache: true
  belongs_to :user, counter_cache: true

  attr_accessible :content, :name, :email, :website, :user_id, :parent_id

  validates :name, :content, presence: true
  validates :email, email_format: true, presence: true

  has_ancestry
end
