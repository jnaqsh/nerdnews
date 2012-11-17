class Comment < ActiveRecord::Base
  belongs_to :story, counter_cache: true
  belongs_to :user, counter_cache: true

  attr_accessible :content, :name, :email, :website, :user_id, :parent_id

  before_validation :smart_add_url_protocol

  validates :name, :content, presence: true
  validates :email, email_format: true, presence: true

  has_ancestry


  private
  
    def smart_add_url_protocol
      if self.website.present?
        unless self.website[/^https?:\/\//]
          self.website = 'http://' + self.website
        end
      end
    end
end
