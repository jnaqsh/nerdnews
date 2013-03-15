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
