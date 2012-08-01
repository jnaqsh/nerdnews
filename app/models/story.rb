class Story < ActiveRecord::Base
  attr_accessible :content, :publish_date, :title, :tag_names

  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, :through => :taggings,
                  :after_add => :calculate_count_and_percentage,
                  :after_remove => :calculate_count_and_percentage
  belongs_to :user

  validates_length_of :title, maximum: 100, minimum: 10
  validates_length_of :content, minimum: 20, maximum: 1000
  validates  :title, :content, presence: true

  attr_reader :tag_names

  searchable do
    text :title, boost: 5
    text :content
    text :comments do
      comments.map(&:content)
    end
    time :publish_date
    text :user do
      user.full_name if user.present?
    end
  end

  def tag_names=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end

  # def comments_count
  #   self.comments.count
  # end
  private

    def calculate_count_and_percentage(tag)
      tag.update_attribute :stories_count, tag.stories.count
      tag.update_attribute :stories_percentage, (tag.stories.count.to_f / Tag.sum(:stories_count).to_f * 100).floor
    end
end
