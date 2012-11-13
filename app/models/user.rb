# encoding:utf-8
class User < ActiveRecord::Base
  attr_accessible :email, :full_name, :website, :password, :password_confirmation, :role_ids, :created_at, :favorite_tags
  has_secure_password

  has_and_belongs_to_many :roles
  has_many :stories
  has_many :comments
  has_many :rating_logs, dependent: :destroy
  has_many :votes
  has_many :identities
  has_many :messages

  validates_presence_of :full_name, :email
  validates :password, confirmation: true, presence: true, on: :create
  validates :email, email_format: true, uniqueness: true
  validates_length_of :full_name, maximum: 30, minimum: 7
  accepts_nested_attributes_for :roles

  before_save :set_new_user_role

  searchable do
    text :full_name, as: :full_name_textp
    text :id
    text :email
    time :created_at
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
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
    Message.where(unread: true, reciver_id: self.id).count
  end

  def favorite_tags_array
    unless self.favorite_tags.blank?
      self.favorite_tags.split(%r{[,|،]\s*})
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
end
