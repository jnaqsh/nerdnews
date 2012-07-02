class User < ActiveRecord::Base
  attr_accessible :email, :full_name, :password_digest
end
