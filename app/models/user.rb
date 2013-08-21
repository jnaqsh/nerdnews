# encoding:utf-8
class User < ActiveRecord::Base
  KARMA_THRESHOLD = 100

  extend FriendlyId
  friendly_id :full_name_foo, use: [:slugged, :history]

  attr_accessible :email, :full_name, :website, :password, :role_ids,
                  :password_confirmation, :favorite_tags, :email_visibility

  has_secure_password

  has_and_belongs_to_many :roles
  has_many :stories
  has_many :comments
  has_many :votes
  has_many :identities
  has_many :sent_messages, class_name: Message, foreign_key: :sender_id
  has_many :received_messages, class_name: Message, foreign_key: :receiver_id
  has_many :activity_logs
  has_many :published_stories, class_name: "Story", foreign_key: "publisher_id"
  has_many :removed_stories, class_name: "Story", foreign_key: "remover_id"

  validates_presence_of :full_name, :email
  validates :email, email_format: true
  validates :password, confirmation: true
  validates_uniqueness_of :email, case_sensitive: false
  validates_length_of :full_name, maximum: 30, minimum: 4
  validates :website, allow_blank: true, uri: true

  accepts_nested_attributes_for :roles

  before_save :set_new_user_role
  before_validation :smart_add_url_protocol

  searchable do
    text :full_name, as: "full_name_textp"
    text :id
    text :email
    time :created_at
  end

  def favored_tags
    @favored_tags ||= FavoredTags.new self
  end

  # role
  def defined_roles
    roles.map do |role|
      role.name
    end
  end

  # role
  def role?(role)
    defined_roles.include? role.to_s
  end

  # messages
  def count_unread_messages
    self.received_messages.where(unread: true).count
  end

  def count_unpublished_stories
    self.stories.not_approved.count
  end

  private

  # role
  def set_new_user_role
    if self.roles.empty?
      self.roles << (Role.find_by_name("new_user") or Role.create(name: "new_user"))
    end
  end

  # friendly id
  def full_name_foo
    "#{full_name}"
  end

  # friendly id
  def normalize_friendly_id(string)
    sep = "-"
    parameterized_string = string
    parameterized_string.gsub!(/[^\w\-اآبپتثجچحخدذرزژسشصضطظعغفقکگلمنوهیءئؤيإأةك۱۲۳۴۵۶۷۸۹۰ٔ‌]+/i, sep)
    unless sep.nil? || sep.empty?
      re_sep = Regexp.escape(sep)
      # No more than one of the separator in a row.
      parameterized_string.gsub!(/#{re_sep}{2,}/, sep)
      # Remove leading/trailing separator.
      parameterized_string.gsub!(/^#{re_sep}|#{re_sep}$/i, '')
    end
    parameterized_string.downcase
  end

  # helper
  def smart_add_url_protocol
    if self.website.present?
      unless self.website[/^https?:\/\//]
        self.website = 'http://' + self.website
      end
    end
  end

  # roles
  protected
  # Searches through users and mark them to be approved or not based on KARMA_THRESHOLD
  def self.promote_users
    users = joins(:roles).where('user_rate > ? and roles.name = "new_user"', User::KARMA_THRESHOLD)
    users.each do |u|
      u.roles = [Role.find_by_name("approved")]
      UserMailer.delay.promotion_message(u.id)
    end
  end
end
