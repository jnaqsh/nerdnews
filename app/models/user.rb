class User < ActiveRecord::Base
  attr_accessible :email, :full_name, :password, :password_confirmation, :role_ids, :created_at
  has_secure_password

  has_and_belongs_to_many :roles
  has_many :stories
  has_many :comments

  validates_presence_of :full_name
  validates :password, confirmation: true, presence: true, on: :create
  validates :email, email_format: true, uniqueness: true
  validates_length_of :full_name, maximum: 30, minimum: 7
  accepts_nested_attributes_for :roles

  searchable do
    text :full_name
    text :email
    time :created_at
  end

  def role?(role)
    defined_roles.include? role.to_s
  end

  def defined_roles
    roles.map do |role|
      role.name
    end
  end
end
