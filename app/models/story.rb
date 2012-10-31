#encoding: utf-8

class Story < ActiveRecord::Base
  attr_accessible :content, :publish_date, :title, :source, :tag_names, :view_counter,
    :positive_votes_count, :negative_votes_count

  extend FriendlyId
  friendly_id :title_foo, use: [:slugged, :history]

  def title_foo
    "#{title}"
  end

  def normalize_friendly_id(string)
    sep = "-"
    parameterized_string = string
    parameterized_string.gsub!(/[^a-z0-9\-_اآبپتثجچحخدذرزژسشصضطظعغفقکگلمنوهیءئؤيإأةك۱۲۳۴۵۶۷۸۹۰ٔ‌]+/i, sep)
    unless sep.nil? || sep.empty?
      re_sep = Regexp.escape(sep)
      # No more than one of the separator in a row.
      parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
      # Remove leading/trailing separator.
      parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/i, '')
    end
    parameterized_string.downcase
  end

  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, :through => :taggings,
                  :after_add => :calculate_count,
                  :after_remove => :calculate_count
  has_many :votes, after_add: :increment_votes_count
  belongs_to :user, counter_cache: true

  scope :not_approved, where(:publish_date => nil)
  scope :approved, where("publish_date", present?)

  validates_length_of :title, maximum: 100, minimum: 10
  validates_length_of :content, minimum: 20, maximum: 1500
  validates  :title, :content, presence: true
  validates :source, allow_blank: true, uri: { :format => /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix }


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

  def mark_as_published
    self.update_attributes publish_date: Time.now
  end

  def user_voted?(user)
    !self.votes.where("user_id = ?", user).blank?
  end

  private

    def calculate_count(tag)
      tag.update_attribute :stories_count, tag.stories.count
    end

    def increment_votes_count
      self.increment! :positive_votes_count
    end
end
