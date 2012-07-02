class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :full_name, :password, :password_confirmation

  validates_presence_of :full_name
  validates :password, confirmation: true, presence: true, on: :create
  validates :email, email_format: true
  validates_length_of :full_name, maximum: 30, minimum: 7
end
