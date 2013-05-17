# encoding:utf-8
class User < ActiveRecord::Base
  KARMA_THRESHOLD = 100

  extend FriendlyId
  friendly_id :full_name_foo, use: [:slugged, :history]

  attr_accessible :email, :full_name, :website, :password, :role_ids,
                  :password_confirmation, :favorite_tags

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

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self.id).deliver
  end

  def signup_confirmation
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.signup_confirmation(self.id).deliver
  end

  def role?(role)
    defined_roles.include? role.to_s
  end

  def defined_roles
    roles.map do |role|
      role.name
    end
  end

  def count_unread_messages
    self.received_messages.where(unread: true).count
  end

  def favorite_tags_array
      self.favorite_tags.split(',') unless favorite_tags.blank?
  end

  def included_tag_as_favorite?(tag)
    favorite_tags_array.include? tag unless favorite_tags_array.blank?
  end

  # appends tag to the favorite tags
  def add_or_remove_favorite_tag(tag)
    if included_tag_as_favorite? tag
      chached_favorite_tags_array = favorite_tags_array
      chached_favorite_tags_array.delete tag
      self.update_attributes(favorite_tags: chached_favorite_tags_array.join(","))
    else
      self.update_attributes(favorite_tags: favorite_tags.to_s + (self.favorite_tags.blank? ? tag : ",#{tag}"))
    end
  end

  private

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def set_new_user_role
    if self.roles.empty?
      self.roles << (Role.find_by_name("new_user") or Role.create(name: "new_user"))
    end
  end

  def full_name_foo
    "#{full_name}"
  end

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

  def smart_add_url_protocol
    if self.website.present?
      unless self.website[/^https?:\/\//]
        self.website = 'http://' + self.website
      end
    end
  end

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
