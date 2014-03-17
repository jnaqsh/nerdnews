# == Schema Information
#
# Table name: activity_logs
#
#  id         :integer          not null, primary key
#  user_id    :string(255)
#  browser    :string(255)
#  ip_address :string(255)
#  controller :string(255)
#  action     :string(255)
#  params     :string(255)
#  note       :text(255)
#  created_at :datetime
#  updated_at :datetime
#

class ActivityLog < ActiveRecord::Base
  belongs_to :user

  searchable do
    text :browser
    text :ip_address
    text :controller
    text :action
    text :params
    text :note, boost: 5
    time :created_at
    text :user do
      if user.present?
        user.full_name
        user.email
      end
    end
  end
end
