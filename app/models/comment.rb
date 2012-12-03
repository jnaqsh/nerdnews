class Comment < ActiveRecord::Base
  include Rakismet::Model

  has_many :votes, as: :voteable
  belongs_to :story, counter_cache: true
  belongs_to :user, counter_cache: true

  attr_accessible :content, :name, :email, :website, :user_id, :parent_id

  before_validation :smart_add_url_protocol

  validates :name, :content, :user_ip, :user_agent, :referrer, presence: true
  validates :email, email_format: true, presence: true
  validates :website, allow_blank: true, uri: true

  has_ancestry

  def user_voted?(user)
    !self.votes.where("user_id = ?", user).blank?
  end

  # check if the parent story is approved
  def approved?
    self.story.approved?
  end

  def add_user_requests_data=(request)
    self.user_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer = request.env['HTTP_REFERER']
  end

  private

    def smart_add_url_protocol
      if self.website.present?
        unless self.website[/^https?:\/\//]
          self.website = 'http://' + self.website
        end
      end
    end
end
