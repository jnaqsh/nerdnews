#encoding: utf-8

class Story < ActiveRecord::Base
  acts_as_paranoid
  acts_as_textcaptcha
  extend FriendlyId

  HIDE_THRESHOLD = -8
  CONTENT_MAX_LENGTH = 1500

  attr_accessible :content, :publish_date, :title, :source,
    :tag_names, :view_counter, :publisher_id, :tag_ids

  belongs_to :remover, class_name: "User"
  belongs_to :publisher, class_name: "User"
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, :through => :taggings,
                  :after_add => :calculate_count,
                  :after_remove => :calculate_count
  has_many :votes, as: :voteable
  belongs_to :user, counter_cache: true

  scope :not_approved, where(:publish_date => nil)
  scope :approved, where("publish_date", present?)

  before_validation :smart_add_url_protocol

  validates_length_of :title, maximum: 100, minimum: 10
  validates_length_of :content, minimum: 250, maximum: CONTENT_MAX_LENGTH
  validates  :title, :content, presence: true
  validates :source, allow_blank: true, uri: true

  attr_reader :tag_names

  searchable do
    integer :id
    text :title, boost: 5
    text :content
    text :comments do
      comments.map(&:content)
    end
    time :publish_date
    time :created_at
    boolean :hide
    text :user do
      user.full_name if user.present?
      user.email if user.present?
    end
    text :tags do
      tags.map(&:name)
    end
  end

  def published?
    publish_date.present? ? true : false
  end

  def perform_textcaptcha?
    !skip_textcaptcha
  end

  def tag_names=(tokens)
    # self.tag_ids = Tag.ids_from_tokens(tokens)
    tags_array = tokens.split(",")
    self.tags.clear
    tags_array.each do |tag|
      found_tag = Tag.find_by_name(tag.strip)
      if !found_tag.blank?
        self.tags << found_tag if !self.tags.include?(found_tag)
      else
        self.tags << Tag.create!(name: tag.strip) if tag.strip.size != 0
      end
    end
  end

  def mark_as_published(user, url)
    self.update_attributes({publish_date: Time.zone.now, publisher: user}, without_protection: true)

    # provide tweet content
    if self.tags && self.tags.first
      tweet_content = "#{self.title} ##{self.tags.first.name}"
    else
      tweet_content = "#{self.title}"
    end

    # conditional due to error on request user spec
    Rails.env.production? ? Tweet.tweet(Twitter::Client.new, tweet_content, url) : true
  end

  def user_voted?(user)
    !self.votes.where("user_id = ?", user).blank?
  end

  def approved?
    self.publish_date.present?
  end

  # FriendlyId, TODO: Move to it's own method
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

protected
  # Searches through recent stories and mark them to hide if
  # too much negative rating is submitted for them
  def self.hide_negative_stories
    recent_stories = where(publish_date: (Time.zone.now.midnight - 1.day)..Time.zone.now.midnight)
    recent_stories.each do |rs|
      rs.update_attribute :hide, true if rs.total_point < Story::HIDE_THRESHOLD
      rs.index!
    end
  end

private
  def calculate_count(tag)
    tag.update_attribute :stories_count, tag.stories.count
  end

  def smart_add_url_protocol
    if self.source.present?
      unless self.source[/^https?:\/\//]
        self.source = 'http://' + self.source
      end
    end
  end
end
