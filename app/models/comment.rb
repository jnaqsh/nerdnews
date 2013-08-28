class Comment < ActiveRecord::Base
  acts_as_paranoid

  include Rakismet::Model

  HIDE_THRESHOLD = -8

  scope :approved, where(approved: true)

  has_many :votes, as: :voteable
  belongs_to :story, counter_cache: true
  belongs_to :user, counter_cache: true

  attr_accessible :content, :name, :email, :website, :parent_id
  rakismet_attrs author: :name, author_email: :email, author_url: :website

  before_validation :smart_add_url_protocol
  before_save :is_spam?, :update_counter

  validates :name, :content, :user_ip, :user_agent, :referrer, presence: true
  validates :email, email_format: true, presence: true
  validates :website, allow_blank: true, uri: true

  has_ancestry

  def user_voted?(user)
    !self.votes.where("user_id = ?", user).blank?
  end

  # check if the parent story is approved
  def parent_approved?
    self.story.approved?
  end

  def add_user_requests_data=(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer = request.env['HTTP_REFERER']
  end

  def mark_as_spam
    self.spam!
    self.update_attribute :approved, false
  end

  def mark_as_not_spam
    self.ham!
    self.update_attribute :approved, true
    Story.increment_counter :comments_count, story.id
  end

  def votes_sum
    positive_votes_count - negative_votes_count
  end

  protected
  # Searches through recent comments and mark them to hide if
  # too much negative rating is submitted for them
  def self.hide_negative_comments
    recent_comments = where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
    recent_comments.each do |comment|
      comment.update_attribute :approved, false if comment.total_point < Comment::HIDE_THRESHOLD
    end
  end

  private

    def smart_add_url_protocol
      if self.website.present?
        unless self.website[/^https?:\/\//]
          self.website = 'http://' + self.website
        end
      end
    end

    def is_spam?
      self.approved = !self.spam?
      true # Send True to not prevent from saving record
    end

    def update_counter
      unless approved
        Story.decrement_counter :comments_count, story.id
      end
    end
end
