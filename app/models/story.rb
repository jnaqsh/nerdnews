class Story < ActiveRecord::Base
  attr_accessible :content, :excerpt, :publish_date, :slug, :title, :user_id
end
