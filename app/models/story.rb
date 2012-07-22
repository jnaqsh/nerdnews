class Story < ActiveRecord::Base
  attr_accessible :content, :excerpt, :publish_date, :title, :tag_names

  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, :through => :taggings

  validates_length_of :title, maximum: 100, minimum: 10
  validates_length_of :content, minimum: 20, maximum: 1000
  validates  :title, :content, :excerpt, presence: true

  attr_writer :tag_names
  before_save :submit_tags

  # setter method to grab Tags and show them in edit form
  def tag_names
    @tag_names || tags.map(&:name).join(', ')
  end

  def submit_tags
    if @tag_names
      self.tags = @tag_names.strip.split(/,\s?/).map do |name|
        Tag.find_or_create_by_name(name.strip)
      end
    end
  end
end
