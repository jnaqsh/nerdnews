#encoding: utf-8

class Story < ActiveRecord::Base
  attr_accessible :content, :publish_date, :title, :source, :tag_names, :view_counter,
    :positive_votes_count, :negative_votes_count, :publisher_id

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

  acts_as_textcaptcha

  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, :through => :taggings,
                  :after_add => :calculate_count,
                  :after_remove => :calculate_count
  has_many :votes, as: :voteable, after_add: :increment_votes_count
  belongs_to :user, counter_cache: true

  scope :not_approved, where(:publish_date => nil)
  scope :approved, where("publish_date", present?)

  before_validation :smart_add_url_protocol

  validates_length_of :title, maximum: 100, minimum: 10
  validates_length_of :content, minimum: 250, maximum: 1500
  validates  :title, :content, presence: true
  validates :source, allow_blank: true, uri: true

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

  def published?
    self.publish_date.present? ? true : false
  end

  def perform_textcaptcha?
    !skip_textcaptcha
  end

  def tag_names=(tokens)
    # self.tag_ids = Tag.ids_from_tokens(tokens)
    self.tag_ids = tokens.split(",")
  end

  def mark_as_published(publisher)
    self.update_attributes publish_date: Time.now
    self.update_attributes publisher_id: publisher.id
  end

  def user_voted?(user)
    !self.votes.where("user_id = ?", user).blank?
  end

  def approved?
    self.publish_date.present?
  end

  def votes_sum
    positive_votes_count - negative_votes_count
  end

  private

    def calculate_count(tag)
      tag.update_attribute :stories_count, tag.stories.count
    end

    def increment_votes_count
      self.increment! :positive_votes_count
    end

    def smart_add_url_protocol
      if self.source.present?
        unless self.source[/^https?:\/\//]
          self.source = 'http://' + self.source
        end
      end
    end
end
