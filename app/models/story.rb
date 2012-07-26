class Story < ActiveRecord::Base
  attr_accessible :content, :excerpt, :publish_date, :title, :tag_names

  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, :through => :taggings
  belongs_to :user

  validates_length_of :title, maximum: 100, minimum: 10
  validates_length_of :content, minimum: 20, maximum: 1000
  validates  :title, :content, :excerpt, presence: true

  attr_reader :tag_names

  def tag_names=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end

  def comments_count
    self.comments.count
  end
end
