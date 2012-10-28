class Message < ActiveRecord::Base
  attr_accessible :user_id, :reciver_id, :message, :subject, :unread

  validates_presence_of :message, :subject, :reciver_id

  belongs_to :user

  def mark_as_read
    self.update_column :unread, false
    self.save
  end
end
