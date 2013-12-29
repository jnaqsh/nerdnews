# == Schema Information
#
# Table name: pages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  permalink  :string(255)
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Page < ActiveRecord::Base
  validates :content, presence: true
  validates :permalink, uniqueness: true, length: {maximum: 50, minimum: 3}, presence: true
  validates :name, length: {maximum: 20, minimum: 3}, presence: true
end
